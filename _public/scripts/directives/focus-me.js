define(['ngDrtvs'], function(ngDrtvs) {
	ngDrtvs.directive('focusMe', ['$rootScope', function($rootScope) {
		return {
			restrict: 'A',
			scope: true,
			link: function(scopee, element, attrs) {
				element[0].focus();
			}
		}
	}]);
});