/** @jsx React.DOM */

(function() {
  var MangaLibraryDropdown = React.createClass({
    changeMangaStatus: function(newStatus) {
      Ember.run(function() {
        var controller = this.props.view.get('controller');
        var libraryEntry = this.props.content;
        controller.send('setStatus', libraryEntry, newStatus);
      }.bind(this));
    },

    removeFromMangaLibrary: function() {
      Ember.run(function() {
        var controller = this.props.view.get('controller');
        var libraryEntry = this.props.content;
        controller.send('removeFromMangaLibrary', libraryEntry);
      }.bind(this));
    },

    changeMangaPrivate: function(newPrivate) {
      Ember.run(function() {
        var controller = this.props.view.get('controller');
        var libraryEntry = this.props.content;
        controller.send('setPrivate', libraryEntry, newPrivate);
      }.bind(this));
    },

    changeMangaNotes: function(event) {
      Ember.run(function() {
        if (this.props.view.get('user.viewingSelf')) {
          this.props.content.set('notes', event.target.value);
          this.forceUpdate();
        }
      }.bind(this));
    },

    toggleRereading: function(event) {
      Ember.run(function() {
        if (this.props.view.get('user.viewingSelf')) {
          var controller = this.props.view.get('controller');
          var libraryEntry = this.props.content;
          controller.send('toggleRereading', libraryEntry);
        }
      }.bind(this));
    },

    changeVolumesRead: function(event) {
      Ember.run(function() {
        if (!this.props.view.get('user.viewingSelf')) { return; }

        var focused = $(event.target).is(":focus");
        var originalVolumesRead = this.props.content.get('volumesRead');
        var volumesRead = parseInt(event.target.value) || 0;

        // Let's not go below zero.
        if (volumesRead < 0) { volumesRead = originalVolumesRead; }

        this.props.content.set('volumesRead', volumesRead);

        if (!focused) {
          Ember.run.debounce(this, this.saveMangaLibraryEntry, 500);
        }
      }.bind(this));
    },

    changeRereadCount: function(event) {
      Ember.run(function() {
        if (!this.props.view.get('user.viewingSelf')) { return; }

        var focused = $(event.target).is(":focus");
        var originalRereadCount = this.props.content.get('rereadCount');
        var rereadCount = parseInt(event.target.value) || 0;

        // Let's not go below zero.
        if (rereadCount < 0) { rereadCount = originalRereadCount; }

        this.props.content.set('rereadCount', rereadCount);

        if (!focused) {
          Ember.run.debounce(this, this.saveMangaLibraryEntry, 500);
        }
      }.bind(this));
    },

    saveMangaLibraryEntry: function (event) {
      Ember.run(function() {
        if (event && event.target.nodeName == "FORM") {
          event.preventDefault();
          event.target.querySelector("input").blur();
        }
        else {
          if (this.props.view.get('user.viewingSelf') && this.props.content.get('isDirty')) {
            var controller = this.props.view.get('controller');
            var libraryEntry = this.props.content;
            controller.send('saveMangaLibraryEntry', libraryEntry);
          }
        }
      }.bind(this));
    },

    componentDidMount: function() {
      Ember.run(function() {
        var notes = this.props.content.get('notes');
        if (notes) {
          $(this.getDOMNode()).find(".fa-book").tooltip('destroy');
          $(this.getDOMNode()).find(".fa-book").tooltip({
            title: notes,
            placement: "left"
          });
        }
      }.bind(this));
    },

    componentDidUpdate: function(prevProps, newProps) {
      this.componentDidMount();
      Ember.run(function() {
        if (this.props.dropdownOpen) {
          if (this.props.view.get('user.viewingSelf')) {
            var controller = this.props.view.get('controller');
            var libraryEntry = this.props.content;
            $(this.getDOMNode()).find(".awesome-rating-widget").AwesomeRating({
              editable: true,
              type: this.props.view.get('user.ratingType'),
              rating: this.props.content.get('rating'),
              update: function (newRating) {
                controller.send('setRating', libraryEntry, newRating);
              }
            });
          }
        }
      }.bind(this));
    },

    goToManga: function(event) {
      Ember.run(function() {
        var modifier = event.shiftKey || event.metaKey || event.altKey || event.ctrlKey,
            secondaryClick = event.button > 0;
        if (!modifier && !secondaryClick) {
          event.preventDefault();
          var router = this.props.view.get('controller.target.router');
          router.transitionTo('manga.index', this.props.content.get('manga.id'));
        }
      }.bind(this));
    },

    render: function() {
      var content = this.props.content;
      var validStatuses = ["Currently Reading", "Plan to Read", "Completed", "On Hold", "Dropped"];

      var saveButtonClass = React.addons.classSet({
        "btn": true,
        "personal-notes-save": true,
        "btn-primary": this.props.content.get('isDirty')
      });

      if (this.props.dropdownOpen) {
        return (
          <div className="library-dropdown">
            <div className="drop-arrow" />
            { this.props.view.get('user.viewingSelf')
              ?
                <div className="col-md-12">
                  <textarea className="personal-notes" placeholder={"Personal notes about " + content.get('manga.displayTitle')} value={this.props.content.get('notes')} onChange={this.changeMangaNotes} />
                  <button className={saveButtonClass} onClick={this.saveMangaLibraryEntry}>Save</button>
                </div>
              : ''
            }
            <div className="col-md-2 no-padding-right hidden-xs hidden-sm">
              <img className="drop-thumb" src={content.get('manga.posterImage')} />
            </div>
            <div className="col-md-6 col-sm-8 hidden-xs">
              <h4><a href={"/manga/" + content.get('manga.id')} onClick={this.goToManga}>{content.get('manga.displayTitle')}</a></h4>
              <ul className="genres">
                {
                  content.get('manga.genres').map(function(genre) {
                    return (<li key={genre}>{genre}</li>);
                  })
                }
              </ul>
              <p className="drop-description">{content.get('manga.synopsis')}</p>
            </div>
            <div className="col-md-4 col-sm-4">
              <div className="drop-options">
                <div className={this.props.view.get('user.viewingSelf') ? '' : 'hidden'}>
                  <div className="btn-group btn-block status-select">
                    <button className="btn btn-block dropdown-toggle" data-toggle="dropdown">
                      {content.get('status')}
                      <i className="fa fa-caret-down" />
                    </button>
                    <ul className="dropdown-menu">
                      {
                        validStatuses.map(function(s) {
                          return (<li key={s}><a onClick={this.changeMangaStatus.bind(this, s)}>{s}</a></li>);
                        }.bind(this))
                      }
                      <li><a onClick={this.removeFromMangaLibrary}>Remove from Library</a></li>
                    </ul>
                  </div>
                  <hr />

                  <div className="text-center">
                    <form className="form-inline" onSubmit={this.saveMangaLibraryEntry}>
                      Volumes Read:
                      <input type="number" className="form-control" style={ {width: "40px", padding: "3px", margin:"0 4px", "text-align": "center"} } value={this.props.content.get('volumesRead')} onChange={this.changeVolumesRead} onBlur={this.saveMangaLibraryEntry} />
                    </form>
                    <hr />
                  </div>

                  <div className="text-center">
                    <form>
                      <label className="radio-inline">
                        <input name="private" type="radio" value="true" checked={this.props.content.get('private')} onChange={this.changeMangaPrivate.bind(this, true)} />
                        Private
                      </label>
                      <label className="radio-inline">
                        <input name="private" type="radio" value="false" checked={!this.props.content.get('private')} onChange={this.changeMangaPrivate.bind(this, false)} />
                        Public
                      </label>
                    </form>
                  </div>
                  <hr />

                  <div className="text-center">
                    <div className="awesome-rating-widget">
                      RATING WIDGET HERE.
                    </div>
                  </div>
                  <hr />
                </div>

                <div className="text-center">
                  <label>
                    <input type="checkbox" checked={this.props.content.get('rereading')} onChange={this.toggleRereading} /> Rereading
                  </label>
                  <hr />
                </div>

                <div className="text-center">
                  <form className="form-inline" onSubmit={this.saveMangaLibraryEntry}>
                    Reread
                    <input type="number" className="form-control" style={ {width: "40px", padding: "3px", margin:"0 4px", "text-align": "center"} } value={this.props.content.get('rereadCount')} onChange={this.changeRereadCount} onBlur={this.saveMangaLibraryEntry} />
                    times.
                  </form>
                </div>
              </div>
            </div>
          </div>
        );
      }
      else {
        return (
          <div />
        );
      }
    }
  });

  var MangaLibraryEntry = React.createClass({
    getInitialState: function() {
      return {dropdownOpen: false};
    },

    toggleDropdown: function(event) {
      Ember.run(function() {
        if (event.target.nodeName !== "INPUT" && event.target.nodeName !== "I") {
          this.setState({dropdownOpen: !this.state.dropdownOpen});
        }
      }.bind(this));
    },

    incrementChapters: function(event) {
      Ember.run(function() {
        this.props.content.incrementProperty('chaptersRead');
        Ember.run.debounce(this, this.saveChaptersRead, 500);
      }.bind(this));
    },


    changeProgress: function(event) {
      Ember.run(function() {
        if (!this.props.view.get('user.viewingSelf')) { return; }

        var originalChaptersRead = this.props.content.get('chaptersRead');
        var chaptersRead = parseInt(event.target.value) || 0;

        // Don't allow exceeding the show's chapter count.
        var mangaChapterCount = this.props.content.get('manga.chapterCount');
        if (mangaChapterCount && chaptersRead > mangaChapterCount) {
          chaptersRead = originalChaptersRead;
        }

        // Let's not go below zero.
        if (chaptersRead < 0) { chaptersRead = originalChaptersRead; }

        this.props.content.set('chaptersRead', chaptersRead);
      }.bind(this));
    },

    saveChaptersRead: function(event) {
      Ember.run(function() {
        if (event && event.target.nodeName == "FORM") {
          event.preventDefault();
          event.target.querySelector("input").blur();
        }
        else {
          if (this.props.content.get('isDirty')) {
            var controller = this.props.view.get('controller');
            var libraryEntry = this.props.content;
            controller.send('saveChaptersRead', libraryEntry);
          }
        }
      }.bind(this));
    },

    render: function() {
      var content = this.props.content;

      var ratingDivClass = React.addons.classSet({
        "list-item-score": true,
        "not-rated": Ember.isNone(content.get('rating'))
      });

      var listGroupClass = React.addons.classSet({
        "list-group-item": true,
        "odd": this.props.index % 2 == 1,
        "even": this.props.index % 2 == 0
      });

      var rating;
      if (content.get('rating')) {
        if (this.props.view.get('user.ratingType') == "advanced") {
          rating = (
            <span>
              <i className="fa fa-star" />
              {' '}
              {content.get('rating').toFixed(1)}
            </span>
          );
        }
        else {
          var iconClass;
          if (content.get('positiveRating')) { iconClass = "fa fa-smile-o"; }
          if (content.get('negativeRating')) { iconClass = "fa fa-frown-o"; }
          if (content.get('neutralRating')) { iconClass = "fa fa-meh-o"; }
          rating = (<i className={iconClass} />);
        }
      }
      else {
        rating = (<span>&mdash;</span>);
      }

      return (
        <div className="library-entry">
          <div className={listGroupClass} onClick={this.toggleDropdown}>
            <div className="list-item-left">
              {content.get('manga.displayTitle')}
              { content.get('private')
                ? <span className="anime-label"><i className="fa fa-eye-slash" /></span>
                : ''
              }
              { content.get('rereading')
                ? <span className="anime-label"><i className="fa fa-repeat" /></span>
                : ''
              }
              { content.get('notes')
                ? <span className="anime-label"><i className="fa fa-book" /></span>
                : ''
              }
            </div>
            <div className="list-item-right">
              <div className="list-item-progress">
                { this.props.view.get('user.viewingSelf')
                  ? <i title="Increment chapter count" className="episode-increment" onClick={this.incrementChapters} />
                  : '' }
                <form style={ {display: "inline"} } onSubmit={this.saveChaptersRead} >
                  <input className="input-progress" type="text" pattern="[0-9]*" value={content.get('chaptersRead')} onChange={this.changeProgress} onBlur={this.saveChaptersRead} />
                </form>
                <span className="progress-sep">/</span>
                <span className="list-item-total">{content.get('manga.displayChapterCount')}</span>
              </div>
              <div className={ratingDivClass}>
                {rating}
              </div>
              <div className="list-item-type">
                {content.get('manga.mangaType')}
              </div>
            </div>
          </div>

          <MangaLibraryDropdown dropdownOpen={this.state.dropdownOpen} content={content} view={this.props.view} />
        </div>
      );
    }
  });

  var MangaLibrarySection = React.createClass({
    render: function() {
      return (
        <div className="list-group">
          <div className="panel-divider">
            <span>{this.props.content.get('title')}</span>
            <span className="right-align">
              {this.props.content.get('content.length')}
              {' '}
              {this.props.content.get('content.length') == 1 ? 'Title' : 'Titles'}
            </span>
          </div>
          {
            this.props.content.get('content').map(function(entry, i) {
              return (<MangaLibraryEntry key={entry.get('manga.id')} view={this.props.view} content={entry} index={i} />);
            }.bind(this))
          }
        </div>
      );
    }
  });

  this.MangaLibrarySectionsReactComponent = React.createClass({
    render: function() {
      return (
        <div>
          {
            this.props.content.filter(function (section) {
              return section.get('visible');
            }).map(function (section) {
              return (<MangaLibrarySection key={section.get('title')} content={section} view={this.props.view} />);
            }.bind(this))
          }
        </div>
      );
    }
  });
})();
