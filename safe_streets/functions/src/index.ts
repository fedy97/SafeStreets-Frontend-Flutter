//I used typescript language to deploy cloud functions on firebase

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as express from 'express';
import * as bodyParser from "body-parser";

admin.initializeApp(functions.config().firebase);

const app = express();
const main = express();
const db = admin.firestore();

main.use('/api/v1', app);
main.use(bodyParser.json());

export const webApi = functions.https.onRequest(main);

app.get('/test', (request, response) => {
    response.send('API responded correctly to the GET request');
});
/*
this will get all the reports of every user. in the app code just add a get request like this:
Response response = await Dio().get("https://safestreets-90f80.firebaseapp.com/api/v1/users");
(you have to import the Dio package). the app will call the api below that will get every report and send back the response.
to print the response just add print(response.toString());
NOTE: in order to deploy on SafeStreet firebase project the function below, I had to run 'firebase deploy' command in the terminal.
*/
app.get('/users', async (request, response) => {
  try {
    const fightQuerySnapshot = await db.collection('users').get();
    const users: FirebaseFirestore.DocumentData[] = [];
    fightQuerySnapshot.forEach(
        (doc) => {
            users.push({
                data: doc.data()
            });
        }
    );
    response.json(users);
  } catch(error){
    response.status(500).send(error);
  }
})

