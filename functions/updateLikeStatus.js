const functions = require('firebase-functions');
const admin = require('firebase-admin');

exports = functions.https.onCall(async (data, context) => {
    const {isLiked, audioTrack} = data;

    const batch = admin.firestore().batch();
    const interactionId = admin.firestore().collection('userInterations').doc().id;

    const interaction = {
        id: interactionId,
        userId: context.auth.uid,
        trackId: audioTrack.id,
        artistId: audioTrack.artistId,
        albumId: audioTrack.albumId,
        interactionType: 'Like',
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
    };

    batch.set(admin.firestore().collection('userInteractions').doc(interactionId), interaction);

    if(isLiked) {
        batch.update(admin.firestore().collection('music').doc(audioTrack.id), {likeCount: admin.firestore.FieldValue.increment(1)});
        batch.update(admin.firestore().collection('artists').doc(audioTrack.artistId), {totalLikes: admin.firestore.FieldValue.increment(1)});  
        batch.update(admin.firestore().collection('albums').doc(audioTrack.albumId), {totalLikes: admin.firestore.FieldValue.increment(1)});  
        batch.update(admin.firestore().collection('artists').doc(audioTrack.artistId)
            .collection('albums').doc(audioTrack.albumId)
            .collection('music').doc(audioTrack.id), {likeCount: admin.firestore.FieldValue.increment(1)});
    } else {
        batch.update(admin.firestore().collection('music').doc(audioTrack.id), {likeCount: admin.firestore.FieldValue.increment(-1)});
        batch.update(admin.firestore().collection('artists').doc(audioTrack.artistId), {totalLikes: admin.firestore.FieldValue.increment(-1)});  
        batch.update(admin.firestore().collection('albums').doc(audioTrack.albumId), {totalLikes: admin.firestore.FieldValue.increment(-1)});  
        batch.update(admin.firestore().collection('artists').doc(audioTrack.artistId)
            .collection('albums').doc(audioTrack.albumId)
            .collection('music').doc(audioTrack.id), {likeCount: admin.firestore.FieldValue.increment(-1)});
    }

    await batch.commit();  
    return {success: true};
});