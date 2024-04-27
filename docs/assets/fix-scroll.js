(function (win) {
  function create() {

    return function (hook) {
      const threshold = 10;

      hook.doneEach(function () {
        let urlId = new URLSearchParams(location.hash.split("?")[1]).get("id");
        if (!urlId) return null;
    
        let lastCheck = 0;
        let identical = 0;
        const element = win.document.getElementById(urlId);
        (function poll() {
          var elDistanceToTop =
            window.scrollY + element.getBoundingClientRect().top;

          if (lastCheck === elDistanceToTop) {
            identical++;
          } else {
            identical = 0;
          }

          lastCheck = elDistanceToTop;

          if (identical > threshold) {
            element.scrollIntoView();
          } else {
            setTimeout(poll, 10);
          }
        })();
      });
    };
  }

  win.ScrollAfterImageLoad = {};
  win.ScrollAfterImageLoad.create = create;

  if (typeof win.$docsify === "object") {
    win.$docsify.plugins = [].concat(create(), win.$docsify.plugins);
  }
})(window);
