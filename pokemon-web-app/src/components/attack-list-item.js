import React from 'react';
import Avatar from 'material-ui/Avatar';
import {List, ListItem} from 'material-ui/List';
import Subheader from 'material-ui/Subheader';
import CommunicationChatBubble from 'material-ui/svg-icons/communication/chat-bubble';
import { withRouter } from 'react-router';

import attacks from './data/Attacks.json'

class AttackListItem extends React.Component {
    render() {
        return <ListItem 
            primaryText={this.props.pokemon.PokemonNickName} 
            secondaryText={this.props.pokemon.Species}
            leftAvatar={<Avatar src={`http://www.pokestadium.com/sprites/xy/${this.props.pokemon.Species.toLowerCase()}.gif`} />}
            rightIcon={<CommunicationChatBubble />}
            onClick={() => this.onClicked()}
        />;
    }

    onClicked() {
        this.props.history.push("/pokemon/" + this.props.pokemon.PokemonId);
    }
}

export default withRouter(AttackListItem);