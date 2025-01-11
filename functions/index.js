/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
admin.initializeApp();

exports.updateLikeStatus = require("./updateLikeStatus")
    .updateLikeStatus;
exports.updateDhammaLikeStatus = require("./updateLikeStatus")
    .updateDhammaLikeStatus;
exports.updateFollowerStatus = require("./updateFollowerStatus")
    .updateFollowerStatus;
exports.updateBhikkhuFollowerStatus = require("./updateFollowerStatus")
    .updateBhikkhuFollowerStatus;
exports.updatePlayStatus = require("./updatePlayStatus")
    .updatePlayStatus;
exports.updateDhammaPlayStatus = require("./updatePlayStatus")
    .updateDhammaPlayStatus;
exports.updateDownloadStatus = require("./updateDownloadStatus")
    .updateDownloadStatus;
exports.updateDhammaDownloadStatus = require("./updateDownloadStatus")
    .updateDhammaDownloadStatus;
exports.updateAlbumPopularitySchedule = require("./updateAlbumPopularity")
    .updateAlbumPopularitySchedule;
exports.onUserInteractionCreate = require("./updateAlbumPopularity")
    .onUserInteractionCreate;
exports.updateCollectionPreferenceSchedule =
require("./updateCollectionPreference")
    .updateCollectionPreferenceSchedule;
exports.onDhammaUserInteractionCreate = require("./updateCollectionPreference")
    .onDhammaUserInteractionCreate;

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
