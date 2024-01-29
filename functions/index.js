const functions = require('firebase-functions');
const axios = require('axios');

exports.searchPlaces = functions.https.onRequest(async (req, res) => {
  functions.logger.info('Request received:', req.query);

  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, PUT, POST, OPTIONS');
  res.set('Access-Control-Allow-Headers', '*');


  const apiKey = 'AIzaSyAP9njE_z7lH2tii68WLoQGju0DF8KryXA';
  const searchQuery = req.query.input || '';
  const languageCode = req.query.language || 'en';

  try {
    const response = await axios.get(
      `https://maps.googleapis.com/maps/api/place/textsearch/json?query=${searchQuery}&key=${apiKey}&language=${languageCode}`
    );

    const places = response.data.results;

    res.status(200).json({ data: { places } });
  } catch (error) {
    functions.logger.error('Error:', error.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});