define(['angular', 'jquery', 'ngUIRouter', 'ng-bootstrap', 'ng-lun-lib', 'ng-cookies'], function(angular, jquery){	
	var serviceModule = angular.module('serviceModule', [])
	,	ctrlModule = angular.module('ctrlModule', ['ui.bootstrap', 'rands', 'services', 'ngCookies'])
	,	routerModule = angular.module('routerModule', ['ui.router'])
	,	drtvModule = angular.module('drtvModule', []);

});