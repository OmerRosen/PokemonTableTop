import React from 'react';
import Avatar from 'material-ui/Avatar';
import {List, ListItem} from 'material-ui/List';
import Subheader from 'material-ui/Subheader';
import CommunicationChatBubble from 'material-ui/svg-icons/communication/chat-bubble';
import { withRouter } from 'react-router';

class TrainerForBattle extends React.Component {
    render() {
        return <ListItem 
            primaryText={this.props.trainer.OwnerName} 
            secondaryText={this.props.trainer.PlayerName}
            rightIcon={<CommunicationChatBubble />}
            onClick={() => this.onClicked()}
        />;
    }

    onClicked() {
        this.props.history.push("/trainer/" + this.props.trainer.OwnerName);
    }
}

export default withRouter(TrainerListItems);