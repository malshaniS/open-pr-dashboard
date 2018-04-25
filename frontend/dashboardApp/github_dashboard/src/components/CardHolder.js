import React from 'react';
import PictureCard from "./cardholder/PictureCard";
import NumberCard from "./cardholder/NumberCard";
import logo from "../resouses/githubLogo.png";

export default class CardHolder extends React.Component {
    render() {
        const url = "https://techcrunch.com/wp-content/uploads/2010/07/github-logo.png?w=512";

        const CardStyle = {
            overflow: "auto",
        };

        return (
            <div style={CardStyle}>
                <table align="center" width="80%">
                    <tr align="center">
                        <td height="10%">
                            <PictureCard imageName={process.env.PUBLIC_URL + '/assets/images/githubLogo.png'} url={"https://github.com"} marginTop={10}/>
                        </td>
                        <td height="10%">
                            <NumberCard content={'total'}/>
                        </td>
                        <td height="10%">
                            <PictureCard imageName={process.env.PUBLIC_URL + '/assets/images/prLogo.png'} url={"https://github.com/wso2"} marginTop={0}/>
                        </td>
                        <td height="10%">
                            <NumberCard content={'late'}/>
                        </td>
                        <td height="10%">
                            <PictureCard imageName={process.env.PUBLIC_URL + '/assets/images/wso2Logo.jpg'} url={"https://wso2.com"} marginTop={50}/>
                        </td>
                    </tr>
                </table>
            </div>
        );
    }
}