sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"gdcapm1app/test/integration/pages/PODetailsList",
	"gdcapm1app/test/integration/pages/PODetailsObjectPage",
	"gdcapm1app/test/integration/pages/POItemsObjectPage"
], function (JourneyRunner, PODetailsList, PODetailsObjectPage, POItemsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('gdcapm1app') + '/test/flpSandbox.html#gdcapm1app-tile',
        pages: {
			onThePODetailsList: PODetailsList,
			onThePODetailsObjectPage: PODetailsObjectPage,
			onThePOItemsObjectPage: POItemsObjectPage
        },
        async: true
    });

    return runner;
});

