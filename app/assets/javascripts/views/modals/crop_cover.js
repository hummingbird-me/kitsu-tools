HB.ModalsCropCoverView = Ember.View.extend({
  cropImage: function(c) {
    var self = this,
        element = this.get('element'),
        canvas = element.querySelector('#cropCanvas'),
        context = canvas.getContext('2d'),
        imageObj = new Image();

    context.fillStyle = 'black';
    context.fillRect(0, 0, canvas.width, canvas.height);

    imageObj.onload = function() {
      context.drawImage(this, c.x, c.y, c.w, c.h, 0, 0, 2800, 720);
      var canvasDataURL = canvas.toDataURL('image/jpeg');
      RGBaster.colors(canvasDataURL, function(payload) {
        return element.querySelector('.modal-content').style.background = payload.dominant;
      });
      return self.set('controller.model.croppedImage', canvasDataURL);
    };
    return imageObj.src = this.get('controller.model.originalImage');
  },

  didInsertElement: function() {
    return Ember.run.next((function() {
      var a, b, x, y,
          imageHeight = this.$("#preview").height(),
          imageWidth = this.$("#preview").width(),
          initialSelect = null;

      if (imageWidth / imageHeight === 1400 / 360) {
        initialSelect = [0, 0, imageWidth, imageHeight];
      } else if (imageWidth / imageHeight > 1400 / 360) {
        y = imageHeight;
        x = 1400 * y / 360;
        a = (imageWidth - x) / 2;
        initialSelect = [a, 0, a + x, y];
      } else if (imageWidth / imageHeight < 1400 / 360) {
        x = imageWidth;
        y = 360 * x / 1400;
        b = (imageHeight - y) / 2;
        initialSelect = [0, b, x, b + y];
      }

      return this.$("#preview").Jcrop({
        aspectRatio: 1400 / 360,
        boxWidth: 500,
        bgColor: 'black',
        setSelect: initialSelect,
        onSelect: (function(c) {
          return this.cropImage(c);
        }).bind(this)
      });
    }).bind(this));
  }
});
