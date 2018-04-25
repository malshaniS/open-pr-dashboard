import React from 'react';

export default class PictureCard extends React.Component {

    render() {

        const pictureCardStyle = {
            height: 150,
            width: 150,
            padding:20,
            border: 10,
            borderColor:"#FFF",
            backgroundColor: "#000",
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
        const pictureStyle= {
            maxWidth: "100%",
            maxHeight: "100%",
            marginTop: this.props.marginTop,
        };

        return (
            <div style={pictureCardStyle} align="center"><a href={this.props.url} target={"_blank"}><img src={this.props.imageName} style={pictureStyle}/></a></div>
        );
    }
}
