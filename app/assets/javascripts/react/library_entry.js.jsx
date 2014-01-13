/** @jsx React.DOM */

var LibraryDropdownReactComponent = React.createClass({
  changeStatus: function(newStatus) {
    this.props.content.set('status', newStatus);
    this.props.content.save().then(Ember.K, function() {
      alert("Something went wrong.");
    });
    this.forceUpdate();
  },

  changePrivate: function(newPrivate) {
    this.props.content.set('private', newPrivate);
    this.props.content.save().then(Ember.K, function() {
      alert("Something went wrong.");
    });
    this.forceUpdate();
  },

  render: function() {
    var content = this.props.content;
    var validStatuses = ["Currently Watching", "Plan to Watch", "Completed", "On Hold", "Dropped"];

    if (this.props.dropdownOpen) {
      return (
        <div className="library-dropdown">
          <div className="drop-arrow" />
          <div className="col-md-12">
            <textarea className="personal-notes" placeholder={"Personal notes about " + content.get('anime.canonicalTitle')} />
          </div>
          <div className="col-md-2 no-padding-right hidden-xs hidden-sm">
            <img className="drop-thumb" src={content.get('anime.posterImage')} />
          </div>
          <div className="col-md-6 col-sm-8 hidden-xs">
            <h4>{content.get('anime.canonicalTitle')}</h4>
            <p className="drop-description">{content.get('anime.synopsis')}</p>
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
                        return (<li key={s}><a onClick={this.changeStatus.bind(this, s)}>{s}</a></li>);
                      }.bind(this))
                    }
                  </ul>
                </div>
                <hr />

                <div className="text-center">
                  <form>
                    <label className="radio-inline">
                      <input name="private" type="radio" value="true" checked={this.props.content.get('private')} onClick={this.changePrivate.bind(this, true)} />
                      Private
                    </label>
                    <label className="radio-inline">
                      <input name="private" type="radio" value="false" checked={!this.props.content.get('private')} onClick={this.changePrivate.bind(this, false)} />
                      Public
                    </label>
                  </form>
                </div>
                <hr />

                <div className="text-center">
                  RATING WIDGET HERE.
                </div>
                <hr />
              </div>

              <div className="text-center">
                <a>view advanced options</a>
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

var LibraryEntryReactComponent = React.createClass({
  getInitialState: function() {
    return {dropdownOpen: false};
  },

  toggleDropdown: function(event) {
    if (event.target.nodeName != "INPUT") {
      this.setState({dropdownOpen: !this.state.dropdownOpen});
    }
  },

  render: function() {
    var content = this.props.content;

    var ratingDivClass = React.addons.classSet({
      "list-item-score": true,
      "not-rated": Ember.isNone(content.get('rating'))
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
      rating = (<span>----</span>);
    }

    return (
      <div className="library-entry">
        <div className="library-overlay">
          <div className="icon">
            <i className="fa fa-spin fa-spinner"></i>
          </div>
        </div>

        <div className="list-group-item" onClick={this.toggleDropdown}>
          <div className="list-item-left">
            {content.get('anime.canonicalTitle')}
          </div>
          <div className="list-item-right">
            <div className="list-item-progress">
              <input className="input-progress" type="number" value={content.get('episodesWatched')} />
              <span className="progress-sep">/</span>
              <span className="list-item-total">{content.get('anime.displayEpisodeCount')}</span>
            </div>
            <div className={ratingDivClass}>
              {rating}
            </div>
            <div className="list-item-type">
              {content.get('anime.showType')}
            </div>
          </div>
        </div>

        <LibraryDropdownReactComponent dropdownOpen={this.state.dropdownOpen} content={content} view={this.props.view} />
      </div>
    );
  }
});

var LibraryEntryGroupReactComponent = React.createClass({
  render: function() {
    return (
      <p>Test</p>
    );
  }
});
