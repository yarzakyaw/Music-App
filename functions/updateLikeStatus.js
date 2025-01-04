const {https} = require("firebase-functions/v2");
const admin = require("firebase-admin");

const COLLECTIONS = {
  USER_INTERACTIONS: "userInteractions",
  DHAMMA_USER_INTERACTIONS: "dhammaUserInteractions",
  MUSIC: "music",
  ARTISTS: "artists",
  ALBUMS: "albums",
  DHAMMA: "dhamma",
  BHIKKHUS: "bhikkhus",
  DHAMMA_COLLECTIONS: "dhammaCollections",
};

exports.updateLikeStatus = https.onCall(async (request) => {
  const {isLiked, userId, id, artistId, albumId} = request.data;

  // Validate input data
  if (!userId || !id || !artistId || !albumId) {
    throw new https.HttpsError("invalid-argument",
        "Missing required fields");
  }

  const batch = admin.firestore().batch();
  const interactionId = admin.firestore()
      .collection(COLLECTIONS.USER_INTERACTIONS)
      .doc().id;

  const interaction = {
    id: interactionId,
    userId: userId,
    trackId: id,
    artistId: artistId,
    albumId: albumId,
    interactionType: "Like",
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
  };

  batch.set(admin.firestore().collection(COLLECTIONS.USER_INTERACTIONS)
      .doc(interactionId), interaction);

  if (isLiked) {
    batch.update(admin.firestore().collection(COLLECTIONS.MUSIC)
        .doc(id),
    {likeCount: admin.firestore.FieldValue.increment(1)});
    batch.update(admin.firestore().collection(COLLECTIONS.ARTISTS)
        .doc(artistId),
    {totalLikes: admin.firestore.FieldValue.increment(1)});
    batch.update(admin.firestore().collection(COLLECTIONS.ALBUMS)
        .doc(albumId),
    {totalLikes: admin.firestore.FieldValue.increment(1)});
    batch.update(admin.firestore().collection(COLLECTIONS.ARTISTS)
        .doc(artistId)
        .collection(COLLECTIONS.ALBUMS).doc(albumId)
        .collection(COLLECTIONS.MUSIC).doc(id),
    {likeCount: admin.firestore.FieldValue.increment(1)});
  } else {
    batch.update(admin.firestore().collection(COLLECTIONS.MUSIC)
        .doc(id),
    {likeCount: admin.firestore.FieldValue.increment(-1)});
    batch.update(admin.firestore().collection(COLLECTIONS.ARTISTS)
        .doc(artistId),
    {totalLikes: admin.firestore.FieldValue.increment(-1)});
    batch.update(admin.firestore().collection(COLLECTIONS.ALBUMS)
        .doc(albumId),
    {totalLikes: admin.firestore.FieldValue.increment(-1)});
    batch.update(admin.firestore().collection(COLLECTIONS.ARTISTS)
        .doc(artistId)
        .collection(COLLECTIONS.ALBUMS).doc(albumId)
        .collection(COLLECTIONS.MUSIC).doc(id),
    {likeCount: admin.firestore.FieldValue.increment(-1)});
  }

  try {
    await batch.commit();
  } catch (error) {
    console.error("Error committing batch:", error);
    throw new https.HttpsError("internal",
        "Unable to update like status");
  }

  return {success: true};
});

exports.updateDhammaLikeStatus = https.onCall(async (request) => {
  const {isLiked, userId, audioTrack} = request.data;
  // Validate input data
  if (!userId || !audioTrack || !audioTrack.id ||
    !audioTrack.artistId || !audioTrack.albumId) {
    throw new https.HttpsError("invalid-argument",
        "Missing required fields");
  }

  const batch = admin.firestore().batch();
  const interactionId = admin.firestore()
      .collection(COLLECTIONS.DHAMMA_USER_INTERACTIONS)
      .doc().id;

  const interaction = {
    id: interactionId,
    userId: userId,
    trackId: audioTrack.id,
    artistId: audioTrack.artistId,
    albumId: audioTrack.albumId,
    interactionType: "Like",
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
  };

  batch.set(admin.firestore()
      .collection(COLLECTIONS.DHAMMA_USER_INTERACTIONS)
      .doc(interactionId), interaction);

  if (isLiked) {
    batch.update(admin.firestore().collection(COLLECTIONS.DHAMMA)
        .doc(audioTrack.id),
    {likeCount: admin.firestore.FieldValue.increment(1)});
    batch.update(admin.firestore().collection(COLLECTIONS.BHIKKHUS)
        .doc(audioTrack.artistId),
    {totalLikes: admin.firestore.FieldValue.increment(1)});
    batch.update(admin.firestore().collection(COLLECTIONS.DHAMMA_COLLECTIONS)
        .doc(audioTrack.albumId),
    {totalLikes: admin.firestore.FieldValue.increment(1)});
    batch.update(admin.firestore().collection(COLLECTIONS.BHIKKHUS)
        .doc(audioTrack.artistId)
        .collection(COLLECTIONS.DHAMMA_COLLECTIONS).doc(audioTrack.albumId)
        .collection(COLLECTIONS.DHAMMA).doc(audioTrack.id),
    {likeCount: admin.firestore.FieldValue.increment(1)});
  } else {
    batch.update(admin.firestore().collection(COLLECTIONS.DHAMMA)
        .doc(audioTrack.id),
    {likeCount: admin.firestore.FieldValue.increment(-1)});
    batch.update(admin.firestore().collection(COLLECTIONS.BHIKKHUS)
        .doc(audioTrack.artistId),
    {totalLikes: admin.firestore.FieldValue.increment(-1)});
    batch.update(admin.firestore()
        .collection(COLLECTIONS.DHAMMA_COLLECTIONS)
        .doc(audioTrack.albumId),
    {totalLikes: admin.firestore.FieldValue.increment(-1)});
    batch.update(admin.firestore().collection(COLLECTIONS.BHIKKHUS)
        .doc(audioTrack.artistId)
        .collection(COLLECTIONS.DHAMMA_COLLECTIONS).doc(audioTrack.albumId)
        .collection(COLLECTIONS.DHAMMA).doc(audioTrack.id),
    {likeCount: admin.firestore.FieldValue.increment(-1)});
  }

  try {
    await batch.commit();
  } catch (error) {
    console.error("Error committing batch:", error);
    throw new https.HttpsError("internal",
        "Unable to update like status");
  }

  return {success: true};
});
