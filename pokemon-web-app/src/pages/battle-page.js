import React from 'react';
import Avatar from 'material-ui/Avatar';
import { List, ListItem } from 'material-ui/List';
import TextField from 'material-ui/TextField';
import FlatButton from 'material-ui/FlatButton';
import Subheader from 'material-ui/Subheader';
import Divider from 'material-ui/Divider';
import CommunicationChatBubble from 'material-ui/svg-icons/communication/chat-bubble';


export default class BattlePage extends React.Component {
    render() {
        //        return null;
        return (
            <div className="splitted-screen">
                <div className="half">
                    <h1>Team A</h1>
                    <TextField
                        hintText="Please select Group A's name"/>
                    <FlatButton label="Ok" 
                        onClick={() => this.TeamAName()}
                    />
                    <List>
                    <Subheader>Players</Subheader>
                    <ListItem
                        primaryText="Brendan Lim"
                        leftAvatar={<Avatar src="images/ok-128.jpg" />}
                        rightIcon={<CommunicationChatBubble />}
                    />
                    </List>
                    

                </div>

                <div className="half">
                    <h1>Team B</h1>
                    <TextField
                        hintText="Please select Group B's name"
                    />
                </div>
            </div>
        );
    }
    TeamAName() {
        
    }
}