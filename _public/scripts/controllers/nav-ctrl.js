define(['ctrlModule'], function(ctrlModule){
	ctrlModule.controller('nav-ctrl', ['$scope', '$location', '$state', function($scope, $location, $state) {
				
		$scope.items = [
			{sref: 'home', text: 'Home'},
			{sref: 'aboutme', text: 'About'},
			{sref: 'nodejs', text: 'Node.js'},
			{sref: 'opendata', text: 'Open Data'}
		];
		$scope.items.forEach(function(item, idx){
			if ('#' + $location.path() == item.href)
				$scope.currentIdx = idx;
		});

		$scope.isActive = function(sref) {
			var pattern = new RegExp('^' + sref + '\.{0,1}');

			return pattern.test($state.current.name);
		}
	}]);
});