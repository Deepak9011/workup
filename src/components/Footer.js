import React from 'react';
function Footer(props) {

    const containerStyle = {
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100vh',
      };
    return (
        <>
            <div className='center-container' style={containerStyle}>
                <p id="footer-info">&copy; 2024 Copyright | Deepak Agrawal</p>
            </div>
        </>
    );
    
}

export default Footer;