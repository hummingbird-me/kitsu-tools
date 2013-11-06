Ember.Handlebars.registerBoundHelper 'community-rating', (ratings) ->
  html = '  <ul class="community-rating-wrapper">
              <li class="legend">1</li>
              <li class="rating-column">
                <div class="rating-value" style="height: 0%;"></div>
              </li>
              <li class="rating-column">
                <div class="rating-value" style="height: 0%;"></div>
              </li>
              <li class="rating-column">
                <div class="rating-value" style="height: 0%;"></div>
              </li>
              <li class="rating-column">
                <div class="rating-value" style="height: 0%;"></div>
              </li>
              <li class="rating-column">
                <div class="rating-value" style="height: 0%;"></div>
              </li>
              <li class="rating-column">
                <div class="rating-value" style="height: 0%;"></div>
              </li>
              <li class="rating-column">
                <div class="rating-value" style="height: 33.333333333333336%;"></div>
              </li>
              <li class="rating-column">
                <div class="rating-value" style="height: 100%;"></div>
              </li>
              <li class="rating-column">
                <div class="rating-value" style="height: 66.66666666666667%;"></div>
              </li>
              <li class="rating-column last">
                <div class="rating-value" style="height: 33.333333333333336%;"></div>
              </li>
              <li class="legend">5</li>
            </ul>'
  new Handlebars.SafeString(html)
