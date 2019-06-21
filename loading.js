

var SmartCMS = null;

var SmartCMSLoaded = false;

var isLoadingScreen = true;

var LoadingTime = 0;


pc.script.createLoadingScreen(function (app) {
    
     var addJQuery = function(){
        var scriptElement = document.createElement('script');
        scriptElement.setAttribute('src', 'https://code.jquery.com/jquery-3.3.1.min.js' );
        scriptElement.setAttribute('integrity','sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=');
        scriptElement.setAttribute('crossorigin','anonymous');
        document.head.insertBefore(scriptElement,document.head.firstChild);
     };
             
     var isPreloadingDone = false;
     var isHidingSplash = false;
     var isUsingAdBlock = false;
    
     var loadingScreenTime = new Date();
    
    
     var showSplash = function () {
        // splash wrapper
        var wrapper = document.createElement('div');
        wrapper.id = 'application-splash-wrapper';
        document.body.appendChild(wrapper);

        // splash
        var splash = document.createElement('div');
        splash.id = 'application-splash';
        wrapper.appendChild(splash);
        splash.style.display = 'none';

        
        var logo = document.createElement('img');
        logo.src = 'https://drive.google.com/uc?id=10TPly9wrPbUBMWxJfBA337w75dLltVYd';
        splash.appendChild(logo);
        logo.onload = function () {
            splash.style.display = 'block';
        };
        

        var container = document.createElement('div');
        container.id = 'progress-bar-container';
        splash.appendChild(container);

        var bar = document.createElement('div');
        bar.id = 'progress-bar';
        container.appendChild(bar);
         
        var textContainer = document.createElement('div');
        var text = document.createElement('h1');
        textContainer.appendChild(text);
        text.id = 'progress-text';
        container.appendChild(textContainer);
           
        addJQuery();
         
       window.console.log = function(){};  
       window.console.error = function(){};
       window.console.warn = function(){};  
    };
    
    
    

    var hideSplash = function () {
         
        if(isUsingAdBlock)
            return;
        
        if(isHidingSplash)
            return;
        
        window.isLoadingScreen = false;
        
        isHidingSplash = true;
        
        
        var splash = document.getElementById('application-splash-wrapper');
        splash.parentElement.removeChild(splash);
    };

    var setProgress = function (value) {
        
        
        var bar = document.getElementById('progress-bar');
        if(bar) {
            value = Math.min(1, Math.max(0, value));
            bar.style.width = value * 100 + '%';
        }
        
    };

    var createCss = function () {
        var css = [
            'body {',
            '    background-color: white;',
            '    overflow: hidden;',
            '}',

            '#application-splash-wrapper {',
            '    position: absolute;',
            '    top: 0;',
            '    left: 0;',
            '    height: 100%;',
            '    width: 100%;',
            '    overflow: hidden;',
            '    background-color: white;',
            '}',

            '#application-splash {',
            '    position: absolute;',
            '    top: calc(50% - 28px);',
            '    width: 264px;',
            '    left: calc(50% - 132px);',
            '}',

            '#application-splash img {',
            '    width: 100%;',
            '}',

            '#progress-bar-container {',
            '    margin: 20px auto 0 auto;',
            '    height: 4px;',
            '    width: 100%;',
            '    background-color: white;',
            '}',
            
             '#progress-text {',
             'font-size:36px',
             'display:block',
             'width:100%',
             'height:120px',
             'background-color: white',
             'z-index:2',
            '}',

            '#progress-bar {',
            '    width: 0%;',
            '    height: 100%;',
            '    background-color: orange;',
            '}',
            '@media (max-width: 480px) {',
            '    #application-splash {',
            '        width: 170px;',
            '        left: calc(50% - 85px);',
            '    }',
            '}'
        ].join("\n");

        var style = document.createElement('style');
        style.type = 'text/css';
        if (style.styleSheet) {
          style.styleSheet.cssText = css;
        } else {
          style.appendChild(document.createTextNode(css));
        }

        document.head.appendChild(style);
    };


    createCss();

    showSplash();
    
    var JSON = null;
   var CMSReady = false;
   var SmartCMSAssetReady = false;
    
    app.on('preload:start',function(){
        
        SmartCMS = {
            Events : 
            {
                //Event that will be triggered each time a new CMS cache element has been serialized
                LoadingCacheProgress : "LoadingCacheProgress",
                //Callback when CMS has been cached successfully.
                LoadingCacheSuccess : "LoadingCacheSuccess",
                //Callback when CMS has been cached unsuccessfully.
                LoadingCacheError : "LoadingCacheError",
                //Callback when CMS caching process is done
                LoadingCacheDone : "LoadingCacheDone"
            },

            I:
            null
        };
        
     
        var app = pc.Application.getApplication();
        
        if(isUsingAdBlock)
        {
             
         var adblockAsset = app.assets.findByTag("Adblock");
            adblockAsset[0].once("load" , function (asset) {
                 document.getElementById('application-splash').style.backgroundImage = "url('" +   adblockAsset[0].getFileUrl() + "')";
                 document.getElementById('application-splash').classList.add('application-splash-blocked');
                 
            });
            
           app.assets.load(adblockAsset[0]);
        }
       

        debugger;
        var JSONAsset = app.assets.find('SmartCMSOptions','json');
        var SmartCMSAsset = app.assets.find("SmartCMS.js",'script');
        
        app.assets.on("load:" + JSONAsset.id, function (jsonAsset) {
            JSON = jsonAsset.resource;
            app.fire('preload:SmartCMSOptionsReady',JSON);
        }, this);
        
        
        app.assets.on("load:" + SmartCMSAsset.id, function (cmsAsset) {
             console.log(cmsAsset.resource);
             SmartCMSAssetReady = true;
             app.fire('preload:SmartCMSReady');
        }, this);
        
        app.assets.load(SmartCMSAsset);
        app.assets.load(JSONAsset);
    
    });
    
    var BeginSmartCMS = function(){
        
        
        if(SmartCMS.I !== null)
            return;
        
         
           
            SmartCMS.I = new smartCms(function(){
                            
                            app.fire(SmartCMS.Events.LoadingCacheSuccess);
                            app.fire(SmartCMS.Events.LoadingCacheDone);
                            window.SmartCMSLoaded = true;
                            pc.Application.getApplication().fire("SmartCMSLoadingDone");
                },JSON,app);
                         
                       
             SmartCMS.I.initialize();
        
    };
    
    var OnSmartCMSReady = function(){
        
        CMSReady = true;
    
        if(JSON !== null)
        {
             BeginSmartCMS();
        }
        else
        {
            app.once('preload:SmartCMSOptionsReady',function(JSON){
                BeginSmartCMS();
            });
        }
    };
    
    
    var OnSmartCMSOptionReady = function(){
       
        if(CMSReady)
        {
           
            BeginSmartCMS();
        }
    };
    
    
    app.on('preload:SmartCMSReady',OnSmartCMSReady);
    
    app.on('preload:SmartCMSOptionsReady',OnSmartCMSOptionReady);

    app.on('preload:end', function () {
        app.off('preload:progress');
       
        
    });
    app.on('preload:progress', setProgress);
    
    //app.once(SmartCMS.Events.LoadingCacheDone, hideSplash);
    app.once('start', function(){
        
        LoadingTime = new Date().getTime() - loadingScreenTime.getTime(); 
        
        isPreloadingDone = true;
        
        if(window.SmartCMSLoaded)
        {
            hideSplash();
        }
        else
        {
             app.once("SmartCMSLoadingDone",function(){
                hideSplash();
            });
        }
           
    });
    
       
    
});







    
    
    
    
    
    
    
    
    
    
    
    
    

   