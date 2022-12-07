import QtQuick 2.14
import QtQuick.Controls 2.14

import "../../App"

Page {
    id: root
    title: qsTr("Privacy Policy")

    ScrollView {
        id: scrollView
        anchors.fill: parent

        TextArea {
             id: policy
             textFormat: Text.RichText
             wrapMode: Text.WordWrap
             readOnly: true
             leftPadding: 10
             rightPadding: 100
             text: "<h1>NOTICE</h1>" +
                   "<p><b>Last updated December 12, 2020</b></p>" +
                   "<p>Thank you for choosing to be part of our community at Singer Voice Tester (\"<b>Company</b>\", \"<b>we</b>\", \"<b>us</b>\", \"<b>our</b>\"). We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about this privacy notice, or our practices with regards to your personal information, please contact us at zhitko.vladimir@gmail.com.</p>" +
                   "<p>When you use our mobile application, as the case may be (the \"<b>App</b>\") and more generally, use any of our services (the \"<b>Services</b>\", which include the  App ), we appreciate that you are trusting us with your personal information. We take your privacy very seriously. In this privacy notice, we seek to explain to you in the clearest way possible what information we collect, how we use it and what rights you have in relation to it. We hope you take some time to read through it carefully, as it is important. If there are any terms in this privacy notice that you do not agree with, please discontinue use of our Services immediately.</p>" +
                   "<p>This privacy notice applies to all information collected through our Services (which, as described above, includes our  App ), as well as, any related services, sales, marketing or events.</p>" +
                   "<p><b>Please read this privacy notice carefully as it will help you understand what we do with the information that we collect.</b></p>" +
                   "<p><h2>TABLE OF CONTENTS</h2></p>" +
                   "<p>1. WHAT INFORMATION DO WE COLLECT?</p>" +
                   "<p>2. WILL YOUR INFORMATION BE SHARED WITH ANYONE?</p>" +
                   "<p>3. IS YOUR INFORMATION TRANSFERRED INTERNATIONALLY?</p>" +
                   "<p>4. HOW LONG DO WE KEEP YOUR INFORMATION?</p>" +
                   "<p>5. DO WE COLLECT INFORMATION FROM MINORS?</p>" +
                   "<p>6. WHAT ARE YOUR PRIVACY RIGHTS?</p>" +
                   "<p>7. CONTROLS FOR DO-NOT-TRACK FEATURES</p>" +
                   "<p>8. DO CALIFORNIA RESIDENTS HAVE SPECIFIC PRIVACY RIGHTS?</p>" +
                   "<p>9. DO WE MAKE UPDATES TO THIS NOTICE?</p>" +
                   "<p>1. WHAT INFORMATION DO WE COLLECT?</p>" +
                   "<p><b>Information collected through our App</b></p>" +
                   "<p><b><i>In Short:</i></b> We collect information regarding your mobile device, when you use our App.</p>" +
                   "<p>If you use our App, we also collect the following information:</p>" +
                   "<p><li><ul><i>Mobile Device Access.</i> We may request access or permission to certain features from your mobile device, including your mobile device's camera, microphone, storage, and other features. If you wish to change our access or permissions, you may do so in your device's settings.</ul></li></p>" +
                   "<p>This information is primarily needed to maintain the security and operation of our App, for troubleshooting and for our internal analytics and reporting purposes.</p>" +
                   "<p><h2>2. WILL YOUR INFORMATION BE SHARED WITH ANYONE?</h2></p>" +
                   "<p><b><i>In Short:</i></b> We only share information with your consent, to comply with laws, to provide you with services, to protect your rights, or to fulfill business obligations.</p>" +
                   "<p>We may process or share your data that we hold based on the following legal basis:</p>" +
                   "<p><li><ul><b>Consent:</b> We may process your data if you have given us specific consent to use your personal information for a specific purpose.</ul></li></p>" +
                   "<p><li><ul><b>Legitimate Interests:</b> We may process your data when it is reasonably necessary to achieve our legitimate business interests.</ul></li></p>" +
                   "<p><li><ul><b>Performance of a Contract:</b> Where we have entered into a contract with you, we may process your personal information to fulfill the terms of our contract.</ul></li></p>" +
                   "<p><li><ul><b>Legal Obligations:</b> We may disclose your information where we are legally required to do so in order to comply with applicable law, governmental requests, a judicial proceeding, court order, or legal process, such as in response to a court order or a subpoena (including in response to public authorities to meet national security or law enforcement requirements).</ul></li></p>" +
                   "<p><li><ul><b>Vital Interests:</b> We may disclose your information where we believe it is necessary to investigate, prevent, or take action regarding potential violations of our policies, suspected fraud, situations involving potential threats to the safety of any person and illegal activities, or as evidence in litigation in which we are involved.</ul></li></p>" +
                   "<p>More specifically, we may need to process your data or share your personal information in the following situations:</p>" +
                   "<p><li><ul><b>Business Transfers.</b> We may share or transfer your information in connection with, or during negotiations of, any merger, sale of company assets, financing, or acquisition of all or a portion of our business to another company.</ul></li></p>" +
                   "<p><h2>3. IS YOUR INFORMATION TRANSFERRED INTERNATIONALLY?</h2></p>" +
                   "<p><b><i>In Short:</i></b> We may transfer, store, and process your information in countries other than your own.</p>" +
                   "<p>If you are a resident in the European Economic Area, then these countries may not necessarily have data protection laws or other similar laws as comprehensive as those in your country. We will however take all necessary measures to protect your personal information in accordance with this privacy notice and applicable law.</p>" +
                   "<p><h2>4. HOW LONG DO WE KEEP YOUR INFORMATION?</h2></p>" +
                   "<p><b><i>In Short:</i></b> We keep your information for as long as necessary to fulfill the purposes outlined in this privacy notice unless otherwise required by law.</p>" +
                   "<p>We will only keep your personal information for as long as it is necessary for the purposes set out in this privacy notice, unless a longer retention period is required or permitted by law (such as tax, accounting or other legal requirements).</p>" +
                   "<p>When we have no ongoing legitimate business need to process your personal information, we will either delete or anonymize such information, or, if this is not possible (for example, because your personal information has been stored in backup archives), then we will securely store your personal information and isolate it from any further processing until deletion is possible.</p>" +
                   "<p><h2>5. DO WE COLLECT INFORMATION FROM MINORS?</p></h2>" +
                   "<p><b><i>In Short:</i></b> We do not knowingly collect data from or market to children under 18 years of age.</p>" +
                   "<p>We do not knowingly solicit data from or market to children under 18 years of age. By using the App , you represent that you are at least 18 or that you are the parent or guardian of such a minor and consent to such minor dependent’s use of the App . If we learn that personal information from users less than 18 years of age has been collected, we will deactivate the account and take reasonable measures to promptly delete such data from our records.</p>" +
                   "<p><h2>6. WHAT ARE YOUR PRIVACY RIGHTS?</h2></p>" +
                   "<p><b><i>In Short:</i></b> You may review, change, or terminate your account at any time.</p>" +
                   "<p>If you are a resident in the European Economic Area and you believe we are unlawfully processing your personal information, you also have the right to complain to your local data protection supervisory authority. You can find their contact details here: http://ec.europa.eu/justice/data-protection/bodies/authorities/index_en.htm.</p>" +
                   "<p>If you are a resident in Switzerland, the contact details for the data protection authorities are available here: https://www.edoeb.admin.ch/edoeb/en/home.html.</p>" +
                   "<p><h2>7. CONTROLS FOR DO-NOT-TRACK FEATURES</h2></p>" +
                   "<p>Most web browsers and some mobile operating systems and mobile applications include a Do-Not-Track (\"DNT\") feature or setting you can activate to signal your privacy preference not to have data about your online browsing activities monitored and collected. At this stage no uniform technology standard for recognizing and implementing DNT signals has been finalized. As such, we do not currently respond to DNT browser signals or any other mechanism that automatically communicates your choice not to be tracked online. If a standard for online tracking is adopted that we must follow in the future, we will inform you about that practice in a revised version of this privacy notice. </p>" +
                   "<p><h2>8. DO CALIFORNIA RESIDENTS HAVE SPECIFIC PRIVACY RIGHTS?</h2></p>" +
                   "<p><b><i>In Short:</i></b> Yes, if you are a resident of California, you are granted specific rights regarding access to your personal information.</p>" +
                   "<p>California Civil Code Section 1798.83, also known as the \"Shine The Light\" law, permits our users who are California residents to request and obtain from us, once a year and free of charge, information about categories of personal information (if any) we disclosed to third parties for direct marketing purposes and the names and addresses of all third parties with which we shared personal information in the immediately preceding calendar year. If you are a California resident and would like to make such a request, please submit your request in writing to us using the contact information provided below.</p>" +
                   "<p>If you are under 18 years of age, reside in California, and have a registered account with the App , you have the right to request removal of unwanted data that you publicly post on the App . To request removal of such data, please contact us using the contact information provided below, and include the email address associated with your account and a statement that you reside in California. We will make sure the data is not publicly displayed on the App , but please be aware that the data may not be completely or comprehensively removed from all our systems (e.g. backups, etc.).</p>" +
                   "<p><h2>9. DO WE MAKE UPDATES TO THIS NOTICE?</h2></p>" +
                   "<p><b><i>In Short:</i></b> Yes, we will update this notice as necessary to stay compliant with relevant laws.</p>" +
                   "<p>We may update this privacy notice from time to time. The updated version will be indicated by an updated \"Revised\" date and the updated version will be effective as soon as it is accessible. If we make material changes to this privacy notice, we may notify you either by prominently posting a notice of such changes or by directly sending you a notification. We encourage you to review this privacy notice frequently to be informed of how we are protecting your information.</p>"
        }
    }
}
