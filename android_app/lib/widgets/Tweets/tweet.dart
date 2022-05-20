// ignore_for_file: prefer_const_constructors

import 'package:android_app/constants.dart';
import 'package:android_app/functions/http_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../functions/tweet_functions.dart';
import './retweet.dart';
import './like.dart';
import './commentButton.dart';
import './share.dart';
import './tweetImage.dart';

/// This class is used to represent a tweet.
class Tweet extends StatelessWidget {
  //Tweet id
  final String _key;
  late String _username;
  late String _displayName;
  String _email;

  CircleAvatar _userImage = CircleAvatar(
    backgroundImage: AssetImage('assets/images/user_icon.png'),
    radius: 20.0,
  ); //This will be the profile picture of the user who tweeted it. Get it from userId
  final String _tweetBody;
  List<String> _tweetMedia = <String>[];
  int _repliesCount;
  int _retweetersCount;
  int _favouritersCount;

  bool _isLiked;
  bool _isRetweeted;

  //final DateTime _updatedAt;
  final DateTime _createdAt;
  late final List<String> _taggedUsers;

  final int _iconSize = 20;

  final bool _hideButtons;
  bool _hideReplyTo;

  String _replyToUsername = "@username";

  Tweet.jsonTweet(
      Map<String, dynamic> jsonTweet, bool hideButtons, bool hideReplyTo)
      : _key = jsonTweet['key'] as String,
        _username = jsonTweet['username'] as String,
        _displayName = jsonTweet['name'] as String,
        _email = jsonTweet['email'] as String,
        _tweetBody = jsonTweet['tweetBody'] as String,
        _repliesCount = jsonTweet['repliesCount'] as int,
        _retweetersCount = jsonTweet['retweetersCount'] as int,
        _favouritersCount = jsonTweet['favoritersCount'] as int,
        _createdAt = DateTime.parse(
          jsonTweet['createdAt'] as String,
        ),

        //_userId = jsonTweet['userId'] as int,
        _hideButtons = hideButtons,
        _hideReplyTo = hideReplyTo,
        _isLiked =
            jsonTweet['isLikedByUser'].toString().toLowerCase() == 'true',
        _isRetweeted =
            jsonTweet['isRetweetedByUser'].toString().toLowerCase() == 'true' {
    _tweetMedia = List<String>.from(jsonTweet['tweetMedia']);

    _taggedUsers = List<String>.from(jsonTweet['taggedUsers']);

    //set _userImage
    if (jsonTweet['userImage'] != null) {
      _userImage = CircleAvatar(
        backgroundImage: NetworkImage(jsonTweet['userImage']),
        backgroundColor: Colors.transparent,
        radius: 20.0,
      );
    }
  }

  Tweet.jsonReply(
      Map<String, dynamic> jsonTweet, bool hideButtons, bool hideReplyTo)
      : _key = "",
        _username = jsonTweet['username'] as String,
        _displayName = jsonTweet['name'] as String,
        _email = jsonTweet['email'] as String,
        _tweetBody = jsonTweet['replyBody'] as String,
        _repliesCount = 0,
        _retweetersCount = 0,
        _favouritersCount = 0,

        //_updatedAt = DateTime.parse(jsonTweet['updatedAt'] as String),
        _createdAt = DateTime.parse(jsonTweet['createdAt'] as String),

        //_userId = jsonTweet['userId'] as int,
        _hideButtons = hideButtons,
        _hideReplyTo = hideReplyTo,
        _isLiked =
            jsonTweet['isLikedByUser'].toString().toLowerCase() == 'true',
        _isRetweeted =
            jsonTweet['isRetweetedByUser'].toString().toLowerCase() == 'true' {
    _tweetMedia = List<String>.from(jsonTweet['media']);

    _taggedUsers = List<String>.from(jsonTweet['taggedUsers']);
  }

  /*
    Tweet.jsonTweet(
      Map<String, dynamic> jsonTweet, bool hideButtons, bool hideReplyTo)
      : _userId = jsonTweet['userId'] as int,
        _createdAt = DateTime.parse(jsonTweet['createdAt']),
        _tweetBody = jsonTweet['tweetText'] as String,
        _hideButtons = hideButtons,
        _hideReplyTo = hideReplyTo {
    _tweetMedia = List<String>.from(jsonTweet['images']);
    _favouritersCount = List<int>.from(jsonTweet['favouriters']);
    _retweetersCount = List<int>.from(jsonTweet['retweeters']);
    _repliesCount = List<Map<String, dynamic>>.from(jsonTweet['replies']);

    _username = '@username';
    _displayName = 'Display Name';
  }


  */
  // Map<String, dynamic> toJson() => {
  //       'userId': _userId,
  //       'createdAt': _createdAt.toString(),
  //       'tweetText': _tweetBody,
  //       'images': _tweetMedia,
  //       'favouriters': _favouritersCount,
  //       'retweeters': _retweetersCount,
  //       'replies': _repliesCount,
  //     };

  Map<String, dynamic> toJson() => {
        'key': _key,
        'username': _username,
        'name': _displayName,
        'email': _email,
        'tweetBody': _tweetBody,
        'tweetMedia': _tweetMedia,
        'repliesCount': _repliesCount,
        'retweetersCount': _retweetersCount,
        'favoritersCount': _favouritersCount,
        //'updatedAt': _updatedAt.toString(),
        'createdAt': _createdAt.toString(),
        'taggedUsers': _taggedUsers,
        'isLikedByUser': _isLiked,
        'isRetweetedByUser': _isRetweeted,

        //'userId': _userId,
      };

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return InkWell(
      onTap: () {
        print("Tweet pressed");
        print("No. of replies = " + _repliesCount.toString());
        //get replies here
        //var replies = httpRequestGet("http://" + MY_IP_ADDRESS + ":3000/home/" , headersMap)
        showModalBottomSheet(
            isScrollControlled: true,
            enableDrag: false,
            useRootNavigator: true,
            context: context,
            builder: (bCtx) {
              return FutureBuilder<Widget>(
                future: showReplies(context),
                builder: (BuildContext ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.data ??
                        Container(child: Text("No replies"));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container(
                      height: mediaQuery.size.height * 0.5,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return Text("${snapshot.error}");
                },
              );
            });
      },
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Image widget
            _userImage,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    //User display name
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        _displayName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    //User name
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "$_username . ",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    //Created date
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                //Replying to
                if (!this._hideReplyTo)
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Replying to @$_replyToUsername . ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                //Tweet text
                Container(
                  padding: EdgeInsets.all(5),
                  width: mediaQuery.size.width - _userImage.radius! - 30,
                  child: Text(
                    _tweetBody,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (_tweetMedia.isNotEmpty) TweetImage(_tweetMedia),

                //Row for retweet, comment, like
                if (!_hideButtons)
                  Row(
                    children: [
                      //Comment
                      CommentButton(_repliesCount, _iconSize,
                          Tweet.jsonTweet(toJson(), true, true)),
                      //Retweet
                      Retweet(_retweetersCount, _isRetweeted, _iconSize),
                      //Like
                      Like(_favouritersCount, _isLiked, _iconSize, like),
                      //Share
                      Share(_iconSize),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Show replies
  Future<Widget> showReplies(BuildContext context) async {
    var replies = await getReplies(_key.toString(), _username);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        Expanded(
          child: ListView(
            children: [this],
          ),
        ),
      ],
    );
  }

  // like function
  void like() async {
    //print(_key);
    String url = URL.likeTweet;
    url = url.replaceAll(":tweetId", _key);
    //print(url);

    Map<String, String> headersMap = {
      'Content-Type': 'application/json',
      'Authorization': token
    };
    var response = await httpRequestPost(url, {}, headersMap);

    if (response['message'] == 'added like') {
      _favouritersCount++;
      _isLiked = true;
    } else if (response['message'] == 'removed like') {
      _favouritersCount--;
      _isLiked = false;
    } else {
      print("Error liking the tweet. Response is " + response['message']);
    }
  }

  /// Returns the username
  String getUserName() {
    return _username;
  }

  /// Returns the display name
  String getDisplayName() {
    return _displayName;
  }

  /// Returns the tweet text
  String getTweetText() {
    return _tweetBody;
  }

  /// Returns the tweet media
  List<String> getTweetImages() {
    return _tweetMedia;
  }

  /// Returns the favouriters count
  int getFavouriters() {
    return _favouritersCount;
  }

  /// Returns the retweeters count
  int getRetweetersCount() {
    return _retweetersCount;
  }

  /// Returns the replies count
  int getCommentersCount() {
    return _repliesCount;
  }

  // int getUserId() {
  //   return _userId;
  // }

  /// Returns the created date
  DateTime getCreatedAt() {
    return _createdAt;
  }

  /// Returns the user date
  CircleAvatar getUserImage() {
    return _userImage;
  }

  /// Sets the reply to username
  void setReplyTo(String username) {
    _username = username;
  }
}
