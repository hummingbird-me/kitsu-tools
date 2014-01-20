Hummingbird.ModalsCropCoverView = Ember.View.extend
  cropImage: (c) ->
    that = this

    canvas = @get('element').querySelector('#cropCanvas')
    context = canvas.getContext('2d')
    context.clearRect(0, 0, canvas.width, canvas.height);

    imageObj = new Image()
    imageObj.onload = ->
      context.drawImage this, c.x, c.y, c.w, c.h, 0, 0, 1400, 330
      that.set 'controller.model.croppedImage', canvas.toDataURL('image/jpeg')

    imageObj.src = @get 'controller.model.originalImage'

  didInsertElement: ->
    # Do everything in the next runloop because of this weird timing issue that was
    # causing the initial image dimensions to be read as (24, 24), which in turn
    # was messing up everything.
    Ember.run.next (->
      imageHeight = @$("#preview").height()
      imageWidth = @$("#preview").width()

      initialSelect = null
      if imageWidth / imageHeight == 1400 / 330
        initialSelect = [0, 0, imageWidth, imageHeight]
      else if imageWidth / imageHeight > 1400 / 330
        y = imageHeight
        x = 1400 * y / 330
        a = (imageWidth - x) / 2
        initialSelect = [a, 0, a+x, y]
      else if imageWidth / imageHeight < 1400 / 330
        x = imageWidth
        y = 330 * x / 1400
        b = (imageHeight - y) / 2
        initialSelect = [0, b, x, b+y]

      @$("#preview").Jcrop
        aspectRatio: 1400 / 330
        boxWidth: 500
        setSelect: initialSelect
        onSelect: ((c) ->
          @cropImage(c)
        ).bind(this)
    ).bind(this)
