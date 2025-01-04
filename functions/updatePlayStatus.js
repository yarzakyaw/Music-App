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

exports.updatePlayStatus = https.onCall(async (request) => {
  const {userId, audioTrack} = request.data;

  // Validate input data
  if (!userId || !audioTrack || !audioTrack.id ||
    !audioTrack.artistId || !audioTrack.albumId) {
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
    trackId: audioTrack.id,
    artistId: audioTrack.artistId,
    albumId: audioTrack.albumId,
    interactionType: "Play",
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
  };

  batch.set(admin.firestore().collection(COLLECTIONS.USER_INTERACTIONS)
      .doc(interactionId), interaction);
  batch.update(admin.firestore().collection(COLLECTIONS.MUSIC)
      .doc(audioTrack.id),
  {playCount: admin.firestore.FieldValue.increment(1)});
  batch.update(admin.firestore().collection(COLLECTIONS.ARTISTS)
      .doc(audioTrack.artistId),
  {totalPlayCount: admin.firestore.FieldValue.increment(1)});
  batch.update(admin.firestore().collection(COLLECTIONS.ALBUMS)
      .doc(audioTrack.albumId),
  {totalPlayCount: admin.firestore.FieldValue.increment(1)});
  batch.update(admin.firestore().collection(COLLECTIONS.ARTISTS)
      .doc(audioTrack.artistId)
      .collection(COLLECTIONS.ALBUMS).doc(audioTrack.albumId)
      .collection(COLLECTIONS.MUSIC).doc(audioTrack.id),
  {playCount: admin.firestore.FieldValue.increment(1)});

  try {
    await batch.commit();
  } catch (error) {
    console.error("Error committing batch:", error);
    throw new https.HttpsError("internal",
        "Unable to update play status");
  }

  return {success: true};
});

exports.updateDhammaPlayStatus = https.onCall(async (request) => {
  const {userId, audioTrack} = request.data;
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
    interactionType: "Play",
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
  };

  batch.set(admin.firestore()
      .collection(COLLECTIONS.DHAMMA_USER_INTERACTIONS)
      .doc(interactionId), interaction);
  batch.update(admin.firestore().collection(COLLECTIONS.DHAMMA)
      .doc(audioTrack.id),
  {playCount: admin.firestore.FieldValue.increment(1)});
  batch.update(admin.firestore().collection(COLLECTIONS.BHIKKHUS)
      .doc(audioTrack.artistId),
  {totalPlayCount: admin.firestore.FieldValue.increment(1)});
  batch.update(admin.firestore().collection(COLLECTIONS.DHAMMA_COLLECTIONS)
      .doc(audioTrack.albumId),
  {totalPlayCount: admin.firestore.FieldValue.increment(1)});
  batch.update(admin.firestore().collection(COLLECTIONS.BHIKKHUS)
      .doc(audioTrack.artistId)
      .collection(COLLECTIONS.DHAMMA_COLLECTIONS).doc(audioTrack.albumId)
      .collection(COLLECTIONS.DHAMMA).doc(audioTrack.id),
  {playCount: admin.firestore.FieldValue.increment(1)});

  try {
    await batch.commit();
  } catch (error) {
    console.error("Error committing batch:", error);
    throw new https.HttpsError("internal",
        "Unable to update dhamma play status");
  }

  return {success: true};
});
