BookApp = angular.module("BookApp", [
	"BookAppCtrls",
	"BookRouter"
])


BookRouter = angular.module("BookRouter", [
	"ngRoute"
])

BookRouter.config(["$routeProvider", 
	($routeProvider)->

		$routeProvider.when("/", 
			templateUrl: "/books"
			controller: "BooksCtrl"
		).when("/books/:id", 
			templateUrl: "/books/view"
			controller: "BooksCtrl"
		)
])