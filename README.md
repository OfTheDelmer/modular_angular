# Angular
## More Modular Components



# Angular
## More Modular Components


|Objective|
|	:---	|
| To identify the basic compenents of a Angular application and integrate them together in a manner that creates a canonical example for one to further develop or rexamine afterward.|

### Outline
	
========

* At `ng-app`
* Add Library `angular 1.2.13`
* Setup an `ng-app`
	* Seeing `ng-model`, and [two_way_data_binding](http://docs.angularjs.org/guide/databinding)
* Setup an `ng-controller`
	* The `ng-controller` directive
		* A controller function
	*  [$scope](http://docs.angularjs.org/guide/scope) in a controller
	* Using the `ng-repeat` directive
		* A new `$scope`
		* Iterating through an `Array`
		* Iterating through `(key, values)` 
	* controller actions

*  Setup an App
	*  Setup `config/routes`
	* generate a `BookController` 
	* Download [Angular](http://code.angularjs.org/1.2.13/angular-1.2.13.zip) into `vendor/assets/javascripts`
* Providers, Services, and Factories
* Setup a modular `BookApp`
* Setup a modular `BookAppCtrl`
	* Using `$http`
* Setup with  `ngRoute` 
* Setup with `ngResource`


==========

## Intro With Rails

Let's begin a project in a directory of your choosing:

	rails new book_app
	....
	cd book_app

To get angular you can do one of the following 

	curl -G http://code.angularjs.org/1.2.13/angular-1.2.13.zip > vendor/assets/javascripts/angular && open vendor/assets/javascripts/angular
	
and just `rm vendor/assets/javascripts/angular`, which might be a little over the top and UNIX-y, or you can [download it from here](http://code.angularjs.org/1.2.13/angular-1.2.13.zip), open it, and then 

	mv "~/Downloads/angular-1.2.13" vendor/assets/javascripts/
	

### Including Angular

We need to load our `angular.min.js`, so we add the following to the `assets/javascripts/application.js`

`/application.js`

	...
	//= require jquery
	//= require jquery_ujs
	//= require turbolinks
	// ***** ADD ANGULAR HERE *****
	//= require angular-1.2.13/angular.min
	// *****
	//= require_tree .


### Generating controllers



Let's start off with a `SitesController` and a `BooksController` for our `BookApp` 
	
	rails g controller Sites index
	rails g controller Books 


`views/sites/index.html.erb`

	<div ng-app>
		<input type="text" ng-model="name" placeholder="name">
		<p> HELLO, {{name}}! </p>
	</div>

Now we modify our routes

	BookApp::Application.routes.draw do
		root to: "sites#index"
		resources :books
	end

If angular has loaded correctly then this example should be working at [localhost:3000](localhost:3000)

### A Modular App

Change `<div ng-app>` in the index to `ng-app="BookApp"`

`/books/index.html.erb`

	<div ng-app="BookApp">
		...
	</div>


Now, make a directory in the `app/assets/javascripts` for book related files, i.e.
	
	mkdir app/assets/javascripts/books
	
then make or move `book.js.coffee` in/into `app/assets/javascripts/books` and define a `BookApp` module in it.

`/assets/javascripts/books/book.js.coffee`

	BookApp = angular.module("BookApp", [])

### Adding A Modular Controller

	
Create a `books_controller.js` in the `javascripts/books` folder created above and define a `BookAppCtrls` module in it.


`/assets/javascripts/books/books_controller.js`

	BookAppCtrls = angular.module("BookAppCtrls",[])
	
	BookAppCtrls.controller("BooksCtrl", ["$scope", ($scope)->
	$scope.message = "hello world!"
	]);

Now we can add `BookAppCtrls` as a module in `books.js.coffee`, i.e.


`/assets/javascripts/books/books.js.coffee`

	BookApp = angular.module("BookApp",[
		"BookAppCtrls"
	]);
	
Then we can update our `/sites/index.html.erb`

	<div ng-controller="BooksCtrl">
		{{message}}
	</div>


#### Adding functionality to our controller

Let's define some `fakeBooks` in the `BooksCtrl`

`/assets/javascripts/books_controller.js.coffee`
	
	...
	

	BookAppCtrls.controller("BooksCtrl", ["$scope", 
	($scope)->
		$scope.fakeBooks = [
			id: 1
			title: 'Bog Adventures'
			description: 'A first rails app'
		,
			id: 2
		  	title: 'Happy Tails'
		   	description: 'Using classes in ruby'
		]
		
	])


Now we need to display these `fakeBooks` in a view for our `BooksCtrl`

`/sites/index.html.erb`

	<div ng-controller="BooksCtrl">
		<div ng-repeat="book in fakeBooks">
			<h3>{{book.name}}</h3>
		</div>
	</div>
	
	
### Adding a router

We can handle routing by loading the `ngRoute` module. We begin this by adding the `angular-route` script into our `appliction.js`

`/application.js`

	//= require jquery
	//= require jquery_ujs
	//= require turbolinks
	// ***** ADD ANGULAR HERE *****
	//= require angular-1.2.13/angular.min
	// ***** ADD ANGULAR ROUTER HERE *****
	//= require angular-1.2.13/angular-route.min
	//*****
	//= require_tree .
	

Now we can update our `Book_app.js` to include a router module.


`/assets/javascripts/books/books.js.coffee`

	BookApp = angular.module("BookApp",[
		"BooksRouter"
	]);
	
	# Create our Book module with `ngRoute` dependency
	BooksRouter = angular.module("BooksRouter", ["ngRoute"]);
	
Next we need to configure our route to respond to certain paths

`/assets/javascripts/books/books.js.coffee`

	BooksRouter.config(["$routeProvider",
		($routeProvider)->
			$routeProvider.when("/", 
				templateUrl: "/books"
				controller: "BooksCtrl"
		)
	}]);



Note we add the `index` method to the `BooksController`

`books_controller.rb`

	class BooksController < ApplicationController
	  def index
	  	f.html { render layout: false }
	  end

	end

Then we remove any `ng-controller` tags

`javascripts/books/index.html.erb`

	<div ng-repeat="book in fakeBooks">
		<h3>{{book.name}}</h3>
	</div>
Now all that is left is to render the view in the index.html, and we change it to look as follows.


`/layouts/application.html.erb`

	<body ng-app="BookApp">
		<div ng-view>
		</div>
	</body>


=========
### Exercise:

* Add a route to show an individual `book` by id
	* assume it also has the `BookCtrl` 
	* create a `views/books/show.html.erb` with only the following inside:
		
			<div>
				Hello world
			</div>
	
		
=========


### A Book Show

We might want to start by adding the route to our angular `BooksRouter.config`, which we do by just chaining respective `.when` calls

`/books/books.js.coffee`

	...
	BooksRouter.config(["$routeProvider", ($routeProvider)->
		$routeProvider.when("/", {
		templateUrl: "/books/",
		controller: "BooksCtrl"
		}).
		when("/books/:id",
		templateUrl: "books/view",
		controller: "BookCtrl"
		)
	])
	
Then we need to add a `books#show`,
	
`/controllers/books_controller.rb`

	class BooksController < ApplicationController
		
		...
	
		def show
			render layout: false
		end
	end

and the respective view:

`/views/books/show.html.erb`

	<div>
		Hello, world!
	</div>
	

Next we need a link to be able to navigate to the `show.html.erb`

`/views/books/index.html.erb`

	<div ng-repeat="book in fakeBooks">
		<a href="#/books/{{book.id}}">
			{{book.title}}
		</a>
	</div>
	

### routeParams

Let's create a separate controller to handle showing the details of a particular book, which we will fetch using some `routeParams`, call it `BookDetailsCtrl`.

`/books/books.js.coffee`

	...
	BooksRouter.config(["$routeProvider", ($routeProvider)->
		$routeProvider.when("/", {
		templateUrl: "/books/",
		controller: "BooksCtrl"
		}).
		when("/books/:id",
		templateUrl: "books/view",
		# A BookDetailsCtrl
		controller: "BookDetailsCtrl"
		)
	])

Next we add this controller to our `BookAppCtrls` module as `BookDetailsCtrl` and pass in the `$routeParams`

`books/books_controller.js.coffee`

	BookAppCtrls.controller("BookDetailsCtrl", 	["$scope","$routeParams",($scope, $routeParams)->
		$scope.bookId = $routeParams.id
	])
	


### Making Requests

Let's try making a request for more Books to our server. In order to make a request we should update our `BookController#index` to respond with an array of JSON Books.


`books_controller.rb`

	class BooksController < ApplicationController
	
		def index
			# Add some fake Books
			fake_books = [{title: "blah"},{title: "pretty blah"}]
			
			# respond to the type of request
			respond_to do |f|
				f.html 	{render :layout => false }
				f.json	{render :json => fake_books}
			end
		end
		...
	end

That should be pretty straight forward. Now all we have to do is modify our `BooksCtrl` to make an http  resquest using Angular's `$http` object.


`/assets/javascripts/books/books_controller.js.coffee`
	
	...
	
	// Add the `$http` dependency to list  
	BookAppCtrls.controller("BooksCtrl", ["$scope", "$http", ($scope, $http)->

		...
	]);


Now try writing a get request for more Books as follows.

	BookAppCtrls.controller("BooksCtrl", ["$scope", "$http", 
		($scope)->
			 ... 
			 
			// requesting more Books
			$http.get("/books.json").
				success((newBooks)->
					console.log(newBooks);
					$scope.newBooks = $scope.fakeBooks.concat(newBooks);
			);		
	]);

If we try to do an `$http.post` request we might get a [422](http://www.flickr.com/photos/girliemac/6514473085/in/set-72157628409467125) an unprocessible entity respone from server. This is most likely due to not including a `CSRF` token or authenticity token. Let's create a `Book` model in our database, before we get any further with making `post` requests.


	$ rails g model Book name description
	...
	$ rake db:migrate
	
Now setup a `create` method in our `BooksController`

`books_controller.rb`

	class BooksController < ApplicationController
		...
		
		def create
			new_book = params.require(:book).permit(:name, :description)
			book = Book.create(new_book)
			
			respond_to do |f|
				f.html {redirect_to books_path}
				f.json {render json: book }
			end
		end
	end

Now we can try our first attempt at making a simple `$http` post request with an included authenticity token, which we will refactor shortly.

`/assets/javascripts/books/books_controller.js.coffee`
	
	
	...
	$scope.newBook = {title: "blah"}
	$scope.saveBook = ()->
	
	 	$http({method: "post",
				 url: "/books", 
				 data: {book:
					 		{name: $scope.newBook},
	 				 		"authenticity_token": $('meta[name=csrf-token]').attr('content')} 						 
		}).success((data)->
			console.log(data)
		);
	
 	
 	
### Configuring $httpProvider

As of yet our post request is sending an authenticity token in the data of the params it posts to the server. This is unsightly as truly belongs in the header, and so, we might refactor our `$http` request to reflect this like the following:


`/assets/javascripts/books/books_controller.js.coffee`
	
	$scope.saveBook = ()->
	 	
	 	$http({method: "post",
				 url: "/Books", 
				 data: {Book:
					 		{name: $scope.mock_Book}},
				 headers: {
				 	'X-CSRF-Token': $('meta[name=csrf-token]').attr('content') 
				 }
		}).success((data)->
			console.log(data); 
		);
	

A less redundent way of adding the `X-CSRF-token` to each request is just to setup the `$httpProvider` to have this parameter set in the header by default.

`/assets/javascripts/book.js.coffee`

	...
	BookApp.config(["$httpProvider",($httpProvider)->
		 $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
	]);

### Setting up a service

Making `Book` requests using `$http` should present itself as an opportunity to abstract away some of the common resource logic associated with our model, i.e. `get`, `post`, etc. To handle this angular has a  module for creating resources, which we can then include in our application as a service. 

First, we create our our `BooksService` module.


`/assets/javascripts/books_service.js.coffee`

	var BooksService = angular.module("BooksService", ["ngResource"]);

Then we setup a factory to help manage Books.

	BooksService.factory("BookRes", ["$resource", 
		($resource)->
			// DO SOMETHING HERE
	
	]);

The `$resource` automatically includes most of the requests we'll need for our application except for the `UPDATE` request, so we'll need to add that to any instace of our `Book` resource service. Also, we'll need to specify that we want our service to make resource requests using `:id` paramater in our model, so we specify it as the second argument of our resource as `@id`.


`/assets/javascripts/books/books_service.js`

	BooksService.factory("BookRes", ["$resource", 
		($resource)->
			return $resource("/books/:id.json"
				,{id: "@id"}
				,{update: {method: "PATCH"}
		)		
	]);

Lastly we add the `BookService` dependency to our list of `BookApp` dependencies.

`/books/books.js.coffee`

	var BookApp = angular.module("BookApp",[
		"BooksService",
		"BookAppCtrls",
		"BooksRouter"	
	]);


### Using Resources

Here is a link to how to use [resources](http://docs.angularjs.org/api/ngResource/service/$resource) from angular's site.

In books controller you might instead say

`/books/books_controller.js.coffee`

	BookRes.query((data)->
		console.log(data)
	)

which should log an array of books `[object,object,...]`

### A Book Service



## Resources

* [angular_doc_guide](http://docs.angularjs.org/guide/)
* [routes](http://code.angularjs.org/1.2.14/docs/api/ngRoute/service/$route)
* [resource](http://code.angularjs.org/1.2.14/docs/api/ngResource/service/$resource)
* ["What is a module?"](http://code.angularjs.org/1.2.14/docs/guide/module)
* [egghead](https://egghead.io/)
