#!/usr/bin/perl

use Mojolicious::Lite;
use Mango;
use Mango::BSON ':bson';

## MongoDB remote path
my $uri = 'mongodb://username:password@ds031541.mongolab.com:31541/mydb';

helper mango => sub { state $mango = Mango->new($uri) };

my $menu_items;
$menu_items->{home}=q{};
$menu_items->{info}=q{};

post '/add_new_post' => sub {
  my $self = shift;

  my $form_entry = {
          title => $self->param('post_title'),
           date => $self->param('post_date'),
           desc => $self->param('post_desc'),
          image => $self->param('post_image'),
      available => $self->param('post_enable') ? 1 : 0,
  };
 
  my $collection = $self->mango->db->collection('blog');
  $collection->insert($form_entry);

  #$self->render( json => $form_entry );
  $self->redirect_to('/');
};

get '/record_panel' => sub {
  my $self = shift;

  $self->render(template => 'record_panel', format => 'html', handler => 'ep');
};

any '/add_post' => sub {
  my $self = shift;

  foreach my $key ( keys %{$menu_items} ) {
    $menu_items->{$key} = ($key eq 'info') ? 'active' : '';
  }

  $self->stash(selection => $menu_items);
  $self->render(template => 'add_entry', format => 'html', handler => 'ep');
};

get '/info' => sub {
  my $self = shift;

  foreach my $key ( keys %{$menu_items} ) {
    $menu_items->{$key} = ($key eq 'info') ? 'active' : '';
  }

  $self->stash(selection => $menu_items);
  $self->render(template => 'about', format => 'html', handler => 'ep');
};

get '/meteor_framework' => sub {
  my $self = shift;

  $self->stash(selection => $menu_items);
  $self->render(template => 'meteor_framework', format => 'html', handler => 'ep');
};

get '/mongodb' => sub {
  my $self = shift;

  $self->stash(selection => $menu_items);
  $self->render(template => 'mongodb_tut1', format => 'html', handler => 'ep');
};

get '/' => sub {
  my $self = shift;

  foreach my $key ( keys %{$menu_items} ) {
    $menu_items->{$key} = ($key eq 'home') ? 'active' : '';
  }

  my $collection = $self->mango->db->collection('blog');
  $collection->find->sort({_id => -1})->fields({_id => 0})->all(sub {
    my ($collection, $err, $docs) = @_;

    return $self->reply->exception($err) if $err;
    $self->stash(selection => $menu_items );
    $self->render('home', post => $docs);
  });
};

app->start;

__DATA__

@@ add_entry.html.ep
% title 'Blog post entries';
% layout 'default';
<div class="row">
<fieldset>
<form method="post" action="/add_new_post">
  <legend>Add New Post</legend>
  <div class="row">
    <div class="small-6 columns">
      <label>Title
      <input type="text" name="post_title" placeholder="Post Title" />
      </label>
    </div>
    <div class="small-6 columns">
      <label>Date
      <input type="text" name="post_date" placeholder="Date created" />
      </label>
    </div>
  </div>
  <div class="row">
    <div class="small-12 columns">
      <label>Cover Image(URL)
      <input type="text" name="post_image" placeholder="On your computer, from Dropbox folder locate image and then right click on image folder, select Share Dropbox Link. Then paste the link here." />
    </div>
  </div>
  <div class="row">
    <div class="small-12 columns">
      <label>Description
      <textarea cols="80" name="post_desc" placeholder="Short Desciption"></textarea>
      </label>
    </div>
  </div>
  <div class="row">
    <div class="small-12 columns">
    <label>Post</label>
    <input name="post_enable" type="radio" value=1 id="enable"><label for="enable">Enable</label>
    <input name="post_enable" type="radio" value=0 id="disable"><label for="disable">Disable</label>
    </div>
    <div class="small-12 columns">
    <button type="submit">Add New</a>
    </div>
  </div>
</form>
</fieldset>
</div>



@@ meteor_framework.html.ep
% title 'Meteor';
% layout 'default';

<div class="row panel callout radius">
  <div class="small-12 columns">
  <h4>Meteor </h4>
  <p>Meteor is an open-source real-time in JavaScript web application framework written on top of Nojde.js. Meteor is to Node.js as Rails is to Ruby.
  It integrates tightly with MongoDB and uses the Distributed Data Protocol and a publish-subscribe pattern to automatically propagate data changes to clients in real-time without requiring the developer to write any synchronization code.</p>
  <p>In my opinion, you should consider Meteor, if you would like to develop your project in JavaScript and want to build web or mobile app quickly. In Meteor your application are real-time by default. What I mean by real-time is, the action occurs immediately. Update to data, change and delete occurs instantly.</p>
  <p>Simple todo meteor <a href="http://vogen_todolist.meteor.com">app</a></p>
</div>



@@ mongodb_tut1.html.ep
% layout 'default';
% title 'MongoDB Tutorial';

<div class="row panel callout radius">
  <div class="small-12 columns">
     <em><b>Please note:</b> This tutorial is based on what I know and learned through various sources.</p></em> 
<hr />
    <h3>What is MongoDB?</h3>
    <p>MongoDB is a NoSQL database. Some refer to as "No SQL" or "Not Only SQL". It is a document oriented database that provides, high performance, high availability, and easy scalability. It works on concept of collection and document. MongoDB has an object like in javascript. Someone familiar with javascript would have no problem understanding MongoDB database.</p>
    <h3>Which platform to choose?</h3>
<p>MongoDB is available for platform like windows, linux, mac osx. There is also mongo db image for raspberry pi which you can download, I found through google search. You may choose any platform, learning MongoDB is not difficult. There are steps to install on various platform on MongoDB website.
<br />
<br />
If you prefer to skip installtion process you can use cloud base provider (like www.mongolab.com). No need to worry about installation. Mongodb Lab provides 500MB storage for free. This is perfectly suitable for someone who wants to learn.</p>
<h3>Installing on Mac</h3>
<p>If you have already installed home brew you may follow steps else you have to install home brew which makes installation easier; Homebrew installs the stuff you need that Apple didn’t. It is a missing package manager for OS X. From command line run: brew install mongodb</p>
<h3>How to run MongoDB?</h3>
<p>After installing MongoDB, the most challanging thing is, no!! i am just kidding. To run mongodb just type in mongod on commandline and sit back. This command starts the mongodb server. In order to use query or commands (referred as Mongo Shell) you have to open another terminal and type mongo. This will launch Mongo DB Client or Mongo Shell.
<h3>Where does the data get stored?</h3>
<p>The default location for data is /data/db. Data path can be changed or point to different directory when running mongod command. Command to specify data path. Example: mongod --dpbath /somewhere/db </p>
<h3>MongoDB Shell</h3>
<p>Type db in MongoDB Shell. Which will show currently selected database.</p>
<h3>Check database list</h3> 
<p>In MongoDB Shell type: show dbs</p>
<hr />
<p>That's all for now. Take a break have a kitkat</p>
  </div>
</div>


@@ about.html.ep
% title 'Info';
% layout 'default';
<div class="row panel callout radius">
    <div class="small-12 columns">
      <p>Welcome to my page. My name is vogen, I am a Software Developer. I created this website using mojolicious(real time perl framework written in perl), Foundation (Front-end Framework) responsive layout. The backend database is MongoDB (hosted on Amazon WebServices). I love technology and passionate about. I also love coding and learn new things in everyday of my life.</p>
      <p>I will be posting my everyday work and things I would like to share with those who are interested.</p>
    </div>
</div>



@@ home.html.ep
% title 'Welcome to my page';
% layout 'default';
<div class="row panel callout radius">

    <ul class="small-block-grid-1 medium-block-grid-3 large-block-grid-5">
      % foreach my $item (@$post) {
        % my $image = $item->{image};
        % $image =~ s/www\.dropbox\.com/dl\.dropboxusercontent\.com/g;
        % my $flag = ((not exists $item->{available}) or ($item->{available} == 0) ) ? 'alert' : 'success';
        <li>
          <span class="label <%= $flag %> left"><%= $item->{date} %></span>
          <br/>
          <a href="<%= $item->{link} %>">
          <img src="<%= $image %>" />
          </a>
          <h6><a href="<%= $item->{link} %>"><%= $item->{title} %></a></h6>
          <p><%= $item->{desc} %></p>
        </li>
      % }
    </ul>
</div>



@@ layouts/default.html.ep
<!doctype html>
<html class="no-js" lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title><%= title %></title>
  <link rel="stylesheet" href="css/foundation.css" />
  <link rel="stylesheet" href="css/normalize.css" />
  <link href="icons/foundation-icons.css" rel="stylesheet" />
  <script src="js/vendor/modernizr.js"></script>
</head>
<body>
<div data-magellan-expedition="fixed">
<nav class="top-bar" data-topbar role="navigation">
  <ul class="title-area">
    <li class="name">
      <h1><a href="/">vogen.info</a></h1>
    </li>
     <!-- Remove the class "menu-icon" to get rid of menu icon. Take out "Menu" to just have icon alone -->
    <li class="toggle-topbar menu-icon"><a href="#"><span>Menu</span></a></li>
  </ul>

  <section class="top-bar-section">
      <!-- Left Nav Section -->
    <ul class="left">
      <li class="<%= $selection->{home} %>"><a href="/">Home</a></li>
      <li class="<%= $selection->{info} %>"><a href="/info">Info</a></li>
    </ul>
  </section>
</nav>
</div>
  <br />
  <%= content %>
  <script src="js/vendor/jquery.js"></script>
  <script src="js/foundation.min.js"></script>
  <script src="js/foundation/foundation.equalizer.js"></script>
  <script>
    $(document).foundation();
  </script>
</body>
</html>
