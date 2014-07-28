define(['namespace'], function() {
	var drtvModule = angular.module('drtvModule');
	drtvModule.directive('focusMe', ['$rootScope', function($rootScope) {
		return {
			restrict: 'A',
			scope: true,
			link: function(scopee, element, attrs) {
				element[0].focus();
			}
		}
	}]);
});