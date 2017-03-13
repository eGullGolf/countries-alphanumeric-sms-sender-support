/*
  Scrape list of countries with alphanumeric SMS sender support
  from Twilio and convert it from HTML to CSV

  License:
    Copyright 2017 eGull SAS

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

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
