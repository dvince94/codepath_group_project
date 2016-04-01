# Recipes

Recipes (temporary name) is a recipe challenge app in which a user shares which ingredients he/she contains in his/her fridge. Others then come up with a recipe for the posted challenge or vote for which ones they think are best.

Time spent: **10** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [ ] User can post a recipe building challenge
- [ ] Others should be able to build the recipe using the challenge ingredients
- [x] Recipes built can be voted on to figure which is best
- [x] Display list of recipes

The following **optional** features are implemented:

- [ ] Show the username and creation time for each post
- [ ] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse.
- [ ] User Profiles:
   - [ ] Allow the logged in user to add a profile photo
   - [ ] Display the profile photo with each post
   - [ ] Tapping on a post's username or profile photo goes to that user's profile page
- [ ] Force touch on the ingredients in the challenge post to pop up details about the ingredient (how much is left, how old, etc)
- [ ] Can drag ingredients into your recipe list to hightlight/check off which ones have been used
- [ ] Red mark on extra ingredients being used outside of the challenge
- [ ] Time limit on how long challenge lasts?

## Table/Columns needed in Parse

{
   "_id": "_User",
   "username": "string",
   "password": "string",
   "saved_recipes": "Recipe[]",
   "posted_challenges": "Challenge[]"
}
{
   "_id": "Post",
   "author": "*_User",
   "likes_count": "number"
   "title": "string",
   "descriptions": "string",
   "comments_count": "number",
   "instructions": "string",
   "comments": "Comment[]",
   "category": "number (enum)",
   "image": "file"
}
{
   "_id": "Like",
   "fromUser": "*_User",
   "toPost": "*_Post"
}
{
   "_id": "Comment",
   "description": "string",
}
{
   "_id": "Challenge",
   "author": "*_User",
   "likes_count": "number",
   "title": "string",
   "required_ingredients": "string[]",
   "comments": "Comment[]"
}

## Models
- User: {username, password, saved_recipes, posted_challenges} using PFUser
- Recipe: {author, likes_count, title, comments_count, instructions, comments, category, image}
- Comment: {author, description, likes_count}
- Challenge: {author, likes_count, title, required_ingredients, comments}

## APIs
- Parse API

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/YOFpvtX.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

Walkthrough for week 2 of implemented user stories:

<img src='http://i.imgur.com/xvQYEjl.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## License

    Copyright [2016] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
