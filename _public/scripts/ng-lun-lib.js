(function () {define('services/random',[], function() {
    var randomModule = angular.module('rands', []);
    randomModule.factory('randGenerator', [function() {

        var rG = {};

        rG.random = function(config) {
            var args =  Array.prototype.slice.call(arguments, 0);
            var from, to, number;
            config = angular.extend({from: 0, to: 1, number: 1, isInteger: false}, config);
            /*
            angular.forEach(args, function(arg, idx) {
                if (typeof arg !== 'number') {
                    throw 'arguments of random service must be number';
                }
            });*/
            var ans = [];
            for (var i = 0; i < config.number; i++) {
                ans.push(config.from + Math.random() * (config.to - config.from + 1));
            }

            if (config.isInteger == true) {
                angular.forEach(ans, function(a, idx) {
                    ans[idx] = Math.floor(a);
                });
            }

            return ans;
        }

        rG.randomPick = function(candidates, number) {
            if (!candidates)
                return undefined;
            if (typeof candidates === 'string') {
                var strtmp = candidates;
                candidates = [];
                angular.forEach(strtmp, function(c, idx) {
                    candidates.push(c);
                });
            }
            
            number = number || 1;
            var idx
            ,   ret = [];
            for (var i = 0; i < number; i++) {
                idx = this.random({from: 0, to: candidates.length - 1, number: 1, isInteger: true});
                ret.push(candidates[idx]);
            }
            return ret;
        };

        function isInt(n) {
            return typeof n === 'number' && n % 1 == 0;
        }
        return rG;
    }]);

    return randomModule;
});
define('serviceModule',['services/random'], function(random){
    var services = angular.module('services', [random.name]);
    return services;
});
define('directives/customDrtv',['services/random'], function(rands) {
    var customDrtvs = angular.module('ng-lun-drtv', [rands.name]);
    return customDrtvs;
});
define('directives/depboard',['directives/customDrtv'], function(customDrtv) {
    customDrtv.directive('depboard', ['randGenerator', '$interval', '$interpolate', function(randGenerator, $interval, $interpolate) {
        var text;
        var drtv = {
            restrict: 'AE',
            transclude: true,
            /*scope: {
                text: '@text'
            },*/
            template: ' <div ng-transclude></div>',
            compile: function compile(tElement, tAttrs, transclude) {

                return {
                    pre: function preLink(scope, iElement, iAttrs, controller) {
                        
                    },
                    post: postlink
                }

            },
            
        };

        function postlink(scope, element, attrs, ctrl, $transclude) {
                //var text = scope.text;
                var text = scope.$eval($interpolate(element.text()));
                text = text.substr(1);
                if (text.length == 0)
                    return;
                var words = 'abcdefghijklmnopqrstuvwxyz';
                words = words + words.toUpperCase() + '0123456789';
                var idx = 0;
                var output = randGenerator.randomPick(words, text.length).join('');
                
                //element.text(output);         
                element.empty();
                var spans = [];
                for (var i = 0; i < text.length; i++) {
                    spans.push(angular.element('<span>'));
                    element.append(spans[i]);
                }
                $interval(function() {
                    var thisIdx = idx;
                    var totalTime = 0
                    ,  stepTime = 100
                    ,  stopQuata = randGenerator.random({from: 0, to: 2000, number: 1, isInteger: true})[0];
                    var stop = 
                    $interval(function() {                      
                        totalTime += stepTime;
                        var stopped = false;
                        var c = randGenerator.randomPick(words + text[thisIdx]).join('');
                        spans[thisIdx].text(c);
                        if (c == text[thisIdx] && totalTime >= 1000)  {
                            $interval.cancel(stop);
                            stopped = true;
                        }
                        
                        if (totalTime >= 2000 + stopQuata) {
                            spans[thisIdx].text(text[thisIdx]);                         
                            $interval.cancel(stop);
                            stopped = true;
                        }
                        if (thisIdx == text.length - 1 && stopped == true) {
                            //hook on hover
                            element.on('mouseenter', function() {
                                spans.forEach(function(c2, cIdx) {
                                    var totalTime2 = 0;
                                    var stop2 = 
                                        $interval(function(){
                                            c = randGenerator.randomPick(words + text[cIdx]).join('');
                                            spans[cIdx].text(c);
                                            totalTime2 += stepTime;
                                            if (totalTime2 >= 1000) {
                                                spans[cIdx].text(text[cIdx]);
                                                $interval.cancel(stop2);
                                            }
                                        }, stepTime / 2);
                                })                      
                            });
                        }
                    }, stepTime);
                    
                    idx++;                  
                }, 1, text.length);
            }
        return drtv;
    }]);
});
define('drtvModule',['directives/customDrtv', 'directives/depboard'], function(customDrtv, depboard) {
    //var directives = angular.module('lun.rtvs', [customDrtv.name]);
    return customDrtv;
    //return directives;
});
define('ng-lun-lib',['serviceModule', 'drtvModule'], function(service, drtv) {
    var ngLunLib = angular.module('ng-lun-lib', [service.name, drtv.name]);
    return ngLunLib;
});

require(["ng-lun-lib"]);
}());