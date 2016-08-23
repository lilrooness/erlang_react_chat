import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';

class Input extends Component {
  render() {
    return (
      <div className="Input">
        <input type="text" className="inputBox"
               onChange={this.props.changefun} value={this.props.message} onKeyPress={(e) => {
                 if(e.key == "Enter") {
                   this.props.send()
                 }
               }}/>
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
      <div className="Message" style={style}>{"["+this.props.username+"] "+this.props.message}</div>
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
          <Message message={m.message} username={m.username}
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
      socket: new WebSocket("ws://" + location.hostname+":"+location.port+"/websocket"),
      message: "Please Enter a Message",
      messages: [],
      greyBackground: false
    };

    // this.onMessageChange = this.onMessageChange.bind(this);
    // this.sendMessage = this.sendMessage.bind(this);

    this.state.socket.onopen = () => {
      var username = prompt("Username", "");
      this.state.socket.send(username);
    }

    this.state.socket.onmessage = (event) => {
      var data = JSON.parse(event.data);
      this.messageReceived(data);
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
    this.setState({message: ""});
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
        <Input message={this.state.message} send={this.sendMessage.bind(this)} changefun={this.onMessageChange.bind(this)}/>
      </div>
    );
  }
}

export default App;
