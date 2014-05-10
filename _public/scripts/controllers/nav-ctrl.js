define(['ngCtrls'], function(ctrlModule){
	ctrlModule.controller('nav-ctrl', ['$scope', function($scope) {
		$scope.items = [
			{href: '/about', text: 'About'},
			{href: '/blog', text: 'Blog'}
		];
	}]);
});