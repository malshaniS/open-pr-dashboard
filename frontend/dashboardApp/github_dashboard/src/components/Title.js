import React from 'react';

export default class Title extends React.Component {
    render() {
        const h1Style = {
            fontSize:50,
            margin:5,
            color:"#000",
            fontFamily:"Helvetica",
            textAlign:"center",
            fontWeight:100
        };
        const h2Style = {
            fontSize:20,
            margin:5,
            textAlign:"center",
            color:"#888888",
            fontFamily:"Helvetica",
            fontWeight:100
        };
        const titleStyle = {
            maxWidth: "100%",
        };
        return (
            <div style={titleStyle}>
                <h1 style={h1Style}><br/>Welcome to <img src={process.env.PUBLIC_URL + '/assets/images/githubTitleLogo.png'} height="43" width="150" /> Dashboard<br/></h1>
                <hr width="40%" color={"#ddd"}/>
                <p style={h2Style}><br/>Review and Analyze Open Pull Requests from WSO2 Inc. </p>
            </div>
        );
    }
}
