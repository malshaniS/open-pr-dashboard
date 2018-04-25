import React from 'react';
import Request from 'react-http-request';

var configData = require('../../resouses/config');
const URL = configData.SERVER_URL_COUNT;

export default class NumberCard extends React.Component {
    render() {
        const numberCardStyle = {
            height: 200,
            width: 200,
            padding:20,
            border: 10,
            borderColor:"#FFF",
            backgroundColor: "#222",
            WebkitFilter: "drop-shadow(0px 0px 5px #666)",
            filter: "drop-shadow(0px 0px 5px #666)",
            marginWidth:50,
            marginLeft:15,
            marginRight:15,
            marginTop:30,
            textAlign:"center",
            align:"center",
            borderRadius:30
        };
        const h1Style = {
            fontSize:25,
            margin:5,
            color:"#FFFFFF",
            fontFamily:"Helvetica",
            fontWeight:200,
            marginTop: "16%",
        };
        const totalStyle = {
            fontSize:50,
            margin:5,
            textAlign:"center",
            color:"#33ffbb",
            fontFamily:"Helvetica"
        };
        const lateStyle = {
            fontSize:50,
            margin:5,
            textAlign:"center",
            color:"#4ddbff",
            fontFamily:"Helvetica"
        };

        return (
            <Request
                url={URL}
                method='get'
                accept='json'
            >
                {
                    ({error, result, loading}) => {
                        if (loading) {
                            return <div align="center"><p align="center">loading...</p></div>;
                        } else {
                            return (
                                <div style={numberCardStyle}>
                                    <h1 style={h1Style}>Total number of<br/>{this.props.content==='total'?'Open PRs':'Late Open PRs'}<br/></h1>
                                        <p style={this.props.content==='total'?totalStyle:lateStyle}>{JSON.stringify(result.body[this.props.content])}</p></div>)
                        }
                    }
                }
            </Request>
        );
    }
}
