import React from 'react';

export default class Title extends React.Component {
    constructor(){
        super();
        this.state = {title: "WSO2 Pull Requests Dashboard"}
    }
    render() {
        const titleStyle = {
            fontFamily: "Helvetica",
            fontSize: 16,
            color: "#ffffff",
            textAlign: "left",
            fontWeight: 500,
        };
        const logoStyle = {
            marginRight: 10,
            height: 20,
            width: 50,
            float: "left"
        };

        return (
            <div style={titleStyle}><img src={process.env.PUBLIC_URL + '/assets/images/wso2Logo.jpg'} style={logoStyle}/>{this.state.title}</div>
        );
    }
}
