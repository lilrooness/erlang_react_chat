import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';

class Input extends Component {
  render() {
    return (
      <div className="Input">
        <input type="text" className="inputBox"
               onChange={this.props.changefun} />
        <div className="sendButton"
             onClick={() => {this.props.send()}}>
              Send
            </div>
      </div>
    );
  }
}

class Message extends Component {
  render() {
    var style = {
      "backgroundColor": this.props.background_color
    };
    return (
      <div className="Message" style={style}>{this.props.message}</div>
    );
  }
}

class DisplayArea extends Component {

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className="DisplayArea">
        {this.props.messages.map((m, i) =>
          <Message message={m}
            key={i}
            background_color={i%2==0 ? "grey" : "lightgrey"}/>
        )}
      </div>
    );
  }
}

class App extends Component {

  constructor(props) {
    super(props);
    this.state = {
      socket: new WebSocket("ws://" + location.hostname + ":8080/websocket"),
      message: "",
      messages: [],
      greyBackground: false
    };

    // this.onMessageChange = this.onMessageChange.bind(this);
    // this.sendMessage = this.sendMessage.bind(this);

    this.state.socket.onopen = () => {
      var username = prompt("Username", "");
      this.state.socket.send(username);Joe
    }

    this.state.socket.onmessage = (event) => {
      var data = JSON.parse(event.data);
      this.messageReceived(data.message);
    };
  }

  onMessageChange(e) {
    this.setState({message: e.target.value});
  }

  sendMessage() {
    var data = {
      type: "message",
      message: this.state.message
    };
    this.state.socket.send(JSON.stringify(data));
  }

  messageReceived(message) {
    var messages = this.state.messages;
    messages.push(message);
    this.setState({messages: messages});
  }

  render() {
    return (
      <div className="App">
        <DisplayArea messages={this.state.messages}/>
        <Input send={this.sendMessage.bind(this)} changefun={this.onMessageChange.bind(this)}/>
      </div>
    );
  }
}

export default App;
