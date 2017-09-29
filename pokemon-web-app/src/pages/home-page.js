import React from 'react';
import Avatar from 'material-ui/Avatar';
import {List, ListItem} from 'material-ui/List';
import Subheader from 'material-ui/Subheader';
import TrainerListItem from '../components/trainer-list-item'

export default class HomePage extends React.Component {
    render() {
//        return null;
        return (
            <div>
                <h1>Trainers</h1>
                <List>
                    {this.props.trainers.map(function(x){return <TrainerListItem trainer={x} />})}
                </List>
            </div>
        );
    }
}