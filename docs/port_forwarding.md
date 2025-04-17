# Port Forwarding

## IP Time

1. Check your DHCP IP.

   > [!TIP]
   > Check if **en1** or **en2**, or another. Then, for MacOS:
   >
   > ```bash
   > ipconfig getpacket en1 | grep server_identifier
   > ```

2. Go to _DHCP IP Address_

3. Try Login

4. Click **관리 도구**

5. Click **NAT/라우터 관리** / **포트포워드 설정**

6. Click **규칙 추가**

   - 규칙 이름: ?
   - 규칙 종류: 사용자 정의
   - 프로토콜: TCP
   - 외부 포트: 8081
   - 내부 IP 주소: 현재 접속 된 장치의 IP 주소
   - 내부 포트: 8081

   > [!NOTE]
   > Nexus default port is 8081.
