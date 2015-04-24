$( document ).ready(function() {
'use strict';

var SubmitButton = React.createClass({
  displayName: "SubmitButton",
  fetch_values: function() {
    var map = {};
    $(".active-input").each(function() {
        map[$(this).attr("id")] = $(this).val();
    });
    return map;
  },
  submit: function(e) {
    var values = this.fetch_values();

    console.group("Submit");
    console.log("Values: ", values);
    console.groupEnd();
    /**
    $.ajax({
      url: this.props.url,
      type: 'POST',
      dataType: 'JSON',
      contentType: "application/json",
      processData: false,
      data: JSON.stringify({
        rows: this.props.state.rows,
        form_title: this.props.state.form_title
      }),
      statusCode: {
        200: function (response) {
          location.href = response.responseText;
        },
        500: function (response) {
        }
      }
    });
    **/
  },
  render: function() {
    return (
      <button type="button" onClick={this.submit}> {this.props.text} </button>
    );
  }
});

var FormTitle = React.createClass({
  render: function() {
    return (
      <h2> {this.props.title} </h2>
    );
  }
});

var InputWithLabel = React.createClass({
  displayName: "inputWithLabel",
  handleChange: function (e) {
    // actions.updateTitle(e.target.value, this.props.name);
  },
  render: function() {
    return (
      <div htmlClass="field">
        <label htmlFor={this.props.title}> {this.props.title} </label>
        <input className="active-input" id={this.props.title} type="text" onChange={this.handleChange} />
      </div>
    );
  }
});

var DynamicForm = React.createClass({
  getInitialState: function() {
    var rows = {};
    rows[0] = { autocomplete_from: 'from initial state',
                populate_at: 'from intial state', title: 'from initial state' };
    var data = {};
    return {rows};
  },
  componentDidMount: function() {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      success: function(data) {
        this.setState({rows: data.rows});
        this.setState({title: data.title});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  render: function() {
    return (
      <form>
        <h2> {this.state.title} </h2>
        { Object.keys(this.state.rows).map(function (key, i) {
          if (key === 'form_title') { return; }
          var row = this.state.rows[key];
          return (
            <InputWithLabel key={row.title} title={row.title} autocomplete_from={row.title} />
          );
        }, this)}
        <SubmitButton text="Lagre" state={this.state}
                      url="http://localhost:4000/dynamic_forms"/>
      </form>
    );
  }
});

var mountpoint = document.getElementById('dynamic-form-show');
if ( mountpoint ) {
  var id = $('#dynamic-form-id').text();
  $.trim(id);
  var url = "http://localhost:4000/dynamic_forms/"+id+".json";
  React.render(<DynamicForm url={url}/>, mountpoint);
}


});
