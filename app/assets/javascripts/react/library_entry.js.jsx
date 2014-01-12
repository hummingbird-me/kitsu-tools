/** @jsx React.DOM */

var LibraryDropdownReactComponent = React.createClass({
  render: function() {
    var content = this.props.content;

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
          <div className="col-md-6">
            <h4>{content.get('anime.canonicalTitle')}</h4>
            <p className="drop-description">{content.get('anime.synopsis')}</p>
          </div>
          <div className="col-md-4">
            <div className="drop-options">
              <div className={this.props.view.get('user.viewingSelf') ? '' : 'hidden'}>
                <div className="btn-group btn-block">
                  <button className="btn btn-block dropdown-toggle" data-toggle="dropdown">
                    {content.get('status')}
                    <span className="caret" />
                  </button>
                  <ul className="dropdown-menu">
                    <li>Test</li>
                  </ul>
                </div>
                <hr />

                <div className="text-center">
                  <form>
                    <label className="radio-inline">
                      <input name="private" type="radio" value="true" />
                      Private
                    </label>
                    <label className="radio-inline">
                      <input name="private" type="radio" value="false" />
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
    this.setState({dropdownOpen: !this.state.dropdownOpen});
  },

  render: function() {
    var content = this.props.content;

    var ratingDivClass = "list-item-score";
    if (Ember.isNone(content.get('rating'))) {
      ratingDivClass += " not-rated";
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
              <span>----</span>
            </div>
            <div className="list-item-type">
              <span>{content.get('anime.showType')}</span>
            </div>
          </div>
        </div>

        <LibraryDropdownReactComponent dropdownOpen={this.state.dropdownOpen} content={content} view={this.props.view} />
      </div>
    );
  }
});

