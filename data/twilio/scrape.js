const request = require('request');
const cheerio = require('cheerio');
const artoo = require('artoo-js');
const fs = require('fs');

const CSV_OUTPUT_FILE = 'country_alpha_support.csv'
const options = {
  url:
    'https://support.twilio.com/hc/en-us/articles/223133767',
  headers: {
    'User-Agent':
    'https://github.com/eGullGolf/countries-alphanumeric-sms-sender-support'
  }
}

console.log( "Download page from " + options.url );
function onResponse( error, response, body ) {
  if ( !error && response.statusCode == 200 ) {
    console.log( "Parse HTML..." );
    var html = cheerio.load( body );
    console.log( "Convert HTML to CSV..." );
    artoo.setContext( html );
    fs.writeFileSync(
      CSV_OUTPUT_FILE,
      artoo.writers.csv(
        artoo.scrapeTable('.article-body table')
      )
    );
    console.log( "Done." );
  } else {
    console.err( error );
  }
}
request( options, onResponse );
