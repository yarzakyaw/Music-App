const functions = require("firebase-functions/v2");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");

const COLLECTIONS = {
  LIKES_COUNTS: "lilkesCounts",
  ALBUMS: "albums",
  POPULAR_ALBUMS: "popularAlbums",
  TOP_ALBUMS: "topAlbums",
};

// Daily scheduled function
exports.updateAlbumPopularitySchedule = onSchedule("every 24 hours",
    async (event) => {
      try {
        await updateAlbumPopularityScores();
      } catch (error) {
        console.error("Error updating album popularity scores:", error);
      }
    });

// Trigger on new user interaction
exports.onUserInteractionCreate = onDocumentCreated("userInteractions/{id}",
    async (snap, context) => {
      const data = snap.data();

      if (data.interactionType === "Like") {
        const likesRef = admin.firestore()
            .collection(COLLECTIONS.LIKES_COUNTS)
            .doc("totalLikes");
        try {
          await admin.firestore().runTransaction(async (transaction) => {
            const likeCountDoc = await transaction.get(likesRef);
            const likeCount = likeCountDoc.exists ?
                likeCountDoc.data().count : 0;

            // Increment the like count and check if it reaches 100
            transaction.set(likesRef, {count: likeCount + 1});

            // Check if the count reachs 100
            if (likeCount + 1 >= 100) {
              await updateAlbumPopularityScores();
              // Reset the count after the update
              transaction.update(likesRef, {count: 0});
            }
          });
        } catch (error) {
          console.error("Error processing like interaction:", error);
        }
      }
    });

/**
 * Updates the popularity scores of albums based on various metrics.
 * @return {Promise<void>} A promise that resolves
 * when the update is complete.
 */
async function updateAlbumPopularityScores() {
  const albumSnapshot = await admin
      .firestore()
      .collection(COLLECTIONS.ALBUMS)
      .get();

  const weightPlays = 1;
  const weightLikes = 2;
  const weightShares = 2;
  const weightDownloads = 2;

  const albumScores = albumSnapshot.docs.map((doc) => {
    const data = doc.data();
    return {
      albumImageUrl: data.albumImageUrl,
      albumName: data.albumName,
      artistId: data.artistId,
      id: doc.id,
      popularityScore: (data.totalPlayCount * weightPlays) +
          (data.totalLikes * weightLikes) +
          (data.totalShare * weightShares) +
          (data.totalDownloads * weightDownloads),
      releaseDate: data.releaseDate,
      totalDownloads: data.totalDownloads,
      totalLikes: data.totalLikes,
      totalPlayCount: data.totalPlayCount,
      totalShare: data.totalShare,
    };
  });

  /* const albumScores = [];

  albumSnapshot.forEach((doc) => {
    const data = doc.data();
    const popularityScore = (data.totalPlayCount * weightPlays) +
        (data.totalLikes * weightLikes) +
        (data.totalShare * weightShares) +
        (data.totalDownloads * weightDownloads);

    albumScores.push({
      albumImageUrl: doc.albumImageUrl,
      albumName: data.albumName,
      artistId: data.artistId,
      id: doc.id,
      popularityScore: popularityScore,
      releaseDate: data.releaseDate,
      totalDownloads: data.totalDownloads,
      totalLikes: data.totalLikes,
      totalPlayCount: data.totalPlayCount,
      totalShare: data.totalShare,
    });
  }); */

  // Group scores by aritst Id
  const popularAlbumsByArtist = albumScores
      .reduce((acc, curr) => {
        if (!acc[curr.artistId]) {
          acc[curr.artistId] = [];
        }
        acc[curr.artistId].push(curr);
        return acc;
      }, {});

  // Update popularAlbums collection
  const batch = admin.firestore().batch();
  for (const artistId in popularAlbumsByArtist) {
    if (Object.prototype.hasOwnProperty.call(popularAlbumsByArtist, artistId)) {
      const topAlbums = popularAlbumsByArtist[artistId]
          .sort((a, b) => b.popularityScore - a.popularityScore)
          .slice(0, 3);

      const popularAlbumsRef = admin
          .firestore()
          .collection(COLLECTIONS.POPULAR_ALBUMS)
          .doc(artistId)
          .collection(COLLECTIONS.TOP_ALBUMS);

      // Clear existing top albums
      const existingTopAlbumsSnapshot = await popularAlbumsRef.get();
      existingTopAlbumsSnapshot.forEach((doc) => {
        batch.delete(doc.ref);
      });

      // Add new top albums
      /* topAlbums.forEach(({id, popularityScore, albumImageUrl,
        albumName, releaseDate, totalDownloads,
        totalLikes, totalPlayCount, totalShare}) => {
          batch.set(popularAlbumsRef.doc(id), {
            popularityScore,
            albumImageUrl,
            albumName,
            releaseDate,
            totalDownloads,
            totalLikes,
            totalPlayCount,
            totalShare,
          });
      }); */
      topAlbums.forEach((album) => {
        batch.set(popularAlbumsRef
            .doc(album.id), {
          id: album.id,
          artistId: album.artistId,
          popularityScore: album.popularityScore,
          albumImageUrl: album.albumImageUrl,
          albumName: album.albumName,
          releaseDate: album.releaseDate,
          totalDownloads: album.totalDownloads,
          totalLikes: album.totalLikes,
          totalPlayCount: album.totalPlayCount,
          totalShare: album.totalShare,
        });
      });
    }
  }

  try {
    await batch.commit();
  } catch (error) {
    console.error("Error committing batch:", error);
    throw new functions.https.HttpsError("internal",
        "Unable to update popular albums.");
  }
}
