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
  USERS: "users",
};

exports.updateFollowerStatus = https.onCall(async (request) => {
  const {isFollowed, userId, artist} = request.data;

  // Validate input data
  if (!userId || !artist || !artist.id) {
    throw new https.HttpsError("invalid-argument",
        "Missing required fields");
  }

  try {
    // Retrieve user document
    const userDoc = await admin.firestore()
        .collection(COLLECTIONS.USERS)
        .doc(userId)
        .get();
    const userData = userDoc.data();

    if (!userData) {
      throw new https.HttpsError("not-found",
          "User document not found.");
    }

    const ownedAccountId = userData.ownedAccountId || "";
    const ownedAccountIsIn = userData.ownedAccountIsIn || "";

    const batch = admin.firestore().batch();

    if (isFollowed) {
      // Increment followers
      batch.update(admin.firestore()
          .collection(COLLECTIONS.ARTISTS)
          .doc(artist.id),
      {totalFollowers: admin.firestore.FieldValue.increment(1)});

      // Increment following count for the user
      batch.update(admin.firestore()
          .collection(COLLECTIONS.USERS).doc(userId),
      {totalFollowing: admin.firestore.FieldValue.increment(1)});

      // Increment following count for owned account if applicable
      if (ownedAccountId) {
        batch.update(admin.firestore()
            .collection(ownedAccountIsIn)
            .doc(ownedAccountId),
        {totalFollowing: admin.firestore.FieldValue.increment(1)});
      }
    } else {
      // Increment followers
      batch.update(admin.firestore()
          .collection(COLLECTIONS.ARTISTS)
          .doc(artist.id),
      {totalFollowers: admin.firestore.FieldValue.increment(-1)});

      // Increment following count for the user
      batch.update(admin.firestore()
          .collection(COLLECTIONS.USERS)
          .doc(userId),
      {totalFollowing: admin.firestore.FieldValue.increment(-1)});

      // Increment following count for owned account if applicable
      if (ownedAccountId) {
        batch.update(admin.firestore()
            .collection(ownedAccountIsIn)
            .doc(ownedAccountId),
        {totalFollowing: admin.firestore.FieldValue.increment(-1)});
      }
    }

    // Commit the batch operation
    await batch.commit();

    return {success: true};
  } catch (error) {
    console.error("Error updating follower status:", error);
    throw new https
        .HttpsError("internal",
            "An error occurred while updating follower status.");
  }
});

exports.updateBhikkhuFollowerStatus = https
    .onCall(async (request) => {
      const {isFollowed, userId, bhikkhu} = request.data;

      // Validate input data
      if (!userId || !bhikkhu) {
        throw new https.HttpsError("invalid-argument",
            "Missing required fields");
      }

      try {
        // Retrieve user document
        const userDoc = await admin.firestore()
            .collection(COLLECTIONS.USERS)
            .doc(userId)
            .get();
        const userData = userDoc.data();

        if (!userData) {
          throw new https.HttpsError("not-found",
              "User document not found.");
        }

        const ownedAccountId = userData.ownedAccountId || "";
        const ownedAccountIsIn = userData.ownedAccountIsIn || "";

        const batch = admin.firestore().batch();

        if (isFollowed) {
          // Increment followers
          batch.update(admin.firestore()
              .collection(COLLECTIONS.BHIKKHUS)
              .doc(bhikkhu.id),
          {totalFollowers: admin.firestore.FieldValue.increment(1)});

          // Increment following count for the user
          batch.update(admin.firestore()
              .collection(COLLECTIONS.USERS).doc(userId),
          {totalFollowing: admin.firestore.FieldValue.increment(1)});

          // Increment following count for owned account if applicable
          if (ownedAccountId) {
            batch.update(admin.firestore()
                .collection(ownedAccountIsIn)
                .doc(ownedAccountId),
            {totalFollowing: admin.firestore.FieldValue.increment(1)});
          }
        } else {
          // Increment followers
          batch.update(admin.firestore()
              .collection(COLLECTIONS.BHIKKHUS)
              .doc(bhikkhu.id),
          {totalFollowers: admin.firestore.FieldValue.increment(-1)});

          // Increment following count for the user
          batch.update(admin.firestore()
              .collection(COLLECTIONS.USERS)
              .doc(userId),
          {totalFollowing: admin.firestore.FieldValue.increment(-1)});

          // Increment following count for owned account if applicable
          if (ownedAccountId) {
            batch.update(admin.firestore()
                .collection(ownedAccountIsIn)
                .doc(ownedAccountId),
            {totalFollowing: admin.firestore.FieldValue.increment(-1)});
          }
        }

        // Commit the batch operation
        await batch.commit();

        return {success: true};
      } catch (error) {
        console.error("Error updating follower status:", error);
        throw new https
            .HttpsError("internal",
                "An error occurred while updating follower status.");
      }
    });
