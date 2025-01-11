const functions = require("firebase-functions/v2");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");

const COLLECTIONS = {
  LIKES_COUNTS: "lilkesCounts",
  DHAMMA_COLLECTIONS: "dhammaCollections",
  PREFERRED_COLLECTIONS: "preferredCollections",
  TOP_COLLECTIONS: "topCollections",
};

// Daily scheduled function
exports.updateCollectionPreferenceSchedule = onSchedule("every 24 hours",
    async (event) => {
      try {
        await updateCollectionPreferenceScores();
      } catch (error) {
        console.error("Error updating collection preference scores:", error);
      }
    });

// Trigger on new user interaction
exports.onDhammaUserInteractionCreate =
    onDocumentCreated("dhammaUserInteractions/{id}",
        async (snap, context) => {
          const data = snap.data();

          if (data.interactionType === "Like") {
            const likesRef = admin.firestore()
                .collection(COLLECTIONS.LIKES_COUNTS)
                .doc("totalDhammaLikes");
            try {
              await admin.firestore().runTransaction(async (transaction) => {
                const likeCountDoc = await transaction.get(likesRef);
                const likeCount = likeCountDoc.exists ?
                    likeCountDoc.data().count : 0;

                // Increment the like count and check if it reaches 100
                transaction.set(likesRef, {count: likeCount + 1});

                // Check if the count reachs 100
                if (likeCount + 1 >= 100) {
                  await updateCollectionPreferenceScores();
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
async function updateCollectionPreferenceScores() {
  const collectionSnapshot = await admin
      .firestore()
      .collection(COLLECTIONS.DHAMMA_COLLECTIONS)
      .get();

  const weightPlays = 1;
  const weightLikes = 2;
  const weightShares = 2;
  const weightDownloads = 2;

  const collectionScores = collectionSnapshot.docs.map((doc) => {
    const data = doc.data();
    return {
      collectionImageUrl: data.collectionImageUrl,
      collectionName: data.collectionName,
      bhikkhuId: data.bhikkhuId,
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

  // Group scores by aritst Id
  const preferredCollectionsByBhikkhu = collectionScores
      .reduce((acc, curr) => {
        if (!acc[curr.bhikkhuId]) {
          acc[curr.bhikkhuId] = [];
        }
        acc[curr.bhikkhuId].push(curr);
        return acc;
      }, {});

  // Update popularAlbums collection
  const batch = admin.firestore().batch();
  for (const bhikkhuId in preferredCollectionsByBhikkhu) {
    if (Object.prototype.hasOwnProperty
        .call(preferredCollectionsByBhikkhu, bhikkhuId)) {
      const topCollections = preferredCollectionsByBhikkhu[bhikkhuId]
          .sort((a, b) => b.popularityScore - a.popularityScore)
          .slice(0, 3);

      const preferredCollectionsRef = admin
          .firestore()
          .collection(COLLECTIONS.PREFERRED_COLLECTIONS)
          .doc(bhikkhuId)
          .collection(COLLECTIONS.TOP_COLLECTIONS);

      // Clear existing top albums
      const existingTopCollectionsSnapshot = await preferredCollectionsRef
          .get();
      existingTopCollectionsSnapshot.forEach((doc) => {
        batch.delete(doc.ref);
      });

      topCollections.forEach((collection) => {
        batch.set(preferredCollectionsRef
            .doc(collection.id), {
          id: collection.id,
          bhikkhuId: collection.bhikkhuId,
          popularityScore: collection.popularityScore,
          collectionImageUrl: collection.collectionImageUrl,
          collectionName: collection.collectionName,
          releaseDate: collection.releaseDate,
          totalDownloads: collection.totalDownloads,
          totalLikes: collection.totalLikes,
          totalPlayCount: collection.totalPlayCount,
          totalShare: collection.totalShare,
        });
      });
    }
  }

  try {
    await batch.commit();
  } catch (error) {
    console.error("Error committing batch:", error);
    throw new functions.https.HttpsError("internal",
        "Unable to update preferred collections.");
  }
}
