// Require and initialize the Twilio module with your credentials
var client = require('twilio')('AC41586640491887e8a2253ed24d83acc6', '11edcd98d5decfb69b1cbe3e8d3aa5e0');
 
 Parse.Cloud.define("sendSMS", function(request, response) 
{
  client.sendSms({
    to:'+1 2972286051', 
    from: '+1 6174356357', 
    body: 'Hello world!'
  }, function(err, responseData) { 
    if (err) {
      console.log(err);
    } else { 
      console.log(responseData.from); 
      console.log(responseData.body);
    }
  }
);
});


