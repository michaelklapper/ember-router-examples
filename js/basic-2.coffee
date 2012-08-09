root = exports ? this
root.App = Em.Application.create()

# Models
App.Comment = Em.Object.extend
  title: null
  body: null

App.Trackback = Em.Object.extend
  site: null

App.Post = Em.Object.extend
  title: null
  body: null

# Controllers
App.CommentsController = Em.ArrayController.extend
  content: [App.Comment.create(title: "Comment from annoying internet user")]

App.TrackbacksController = Em.ArrayController.extend
  content: [App.Trackback.create(site: "http://google.com")]

App.ApplicationController = Em.ObjectController.extend()

App.PostsController = Em.ArrayController.extend
  content: []

App.PostController = Em.ObjectController.extend()

# Views
App.CommentsView = Em.View.extend
  templateName: 'comments'

App.TrackbacksView = Em.View.extend
  templateName: 'trackbacks'

App.ApplicationView = Em.View.extend
  templateName: 'application'

App.PostsView = Em.View.extend
  templateName: 'posts'

App.PostView = Em.View.extend
  templateName: 'post'

# Routes
App.Router = Em.Router.extend
  enableLogging: true
  root: Em.Route.extend
    index: Em.Route.extend
      route: '/',
      redirectsTo: 'posts'
    posts: Em.Route.extend
      route: '/posts'
      showPost: Em.Router.transitionTo('post')
      connectOutlets: (router) ->
        router.get("applicationController").connectOutlet('posts', [App.Post.create(id: 1, title: "Post Title", body: "Post Body", intro: "Post Intro")])
    post: Em.Route.extend
      route: '/posts/:post_id'
      showTrackbacks: Ember.Route.transitionTo('trackbacks')
      showComments: Ember.Route.transitionTo('comments')
      connectOutlets: (router, post) ->
        router.get('applicationController').connectOutlet('post', post)
      index: Ember.Route.extend
        route: '/'
        redirectsTo: 'comments'
      comments: Ember.Route.extend
        route: '/comments'
        connectOutlets: (router) ->
          postController = router.get('postController')
          postController.connectOutlet('comments', postController.get('comments'))
      trackbacks: Ember.Route.extend
        route: '/trackbacks'
        connectOutlets: (router) ->
          postController = router.get('postController')
          postController.connectOutlet('trackbacks', postController.get('trackbacks'))

App.router = App.Router.create()

$ ->
  App.initialize(App.router)
