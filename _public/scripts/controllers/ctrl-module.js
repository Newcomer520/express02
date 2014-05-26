define(['angular', 'app', 'ng-bootstrap', 'ng-lun-lib', 'scripts/services/socket-service', 'ng-cookies'], function(angular, app, ngBootstrap, ngLunLib, servies, ngCookies) {
	var ctrls = angular.module('controllers', ['ui.bootstrap', 'rands', 'services', 'ngCookies']);
	return ctrls;
});