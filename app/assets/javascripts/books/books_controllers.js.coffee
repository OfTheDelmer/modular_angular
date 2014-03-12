BooksAppCtrls = angular.module("BookAppCtrls",[])

BooksAppCtrls.controller("BooksCtrl", ["$scope", "$routeParams",
    ($scope, $routeParams)->
        $scope.message = "Hello world!"
        $scope.bookId = $routeParams.id
        $scope.fakeBooks = [
        		id: 1
        		title: "Happy Tails"
        		description: "Fun times"
        	,	
        		id: 2
        		title: "Bog Adventures"
        		description: "Muddy days"
        		]
        console.log $scope.fakeBooks
])