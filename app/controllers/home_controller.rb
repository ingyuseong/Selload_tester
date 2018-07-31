class HomeController < ApplicationController
  require 'uri'
  require 'net/http'
 

  def index
    @dlv_option = {
      'CJ대한통운' => '00034', 
      '한진택배' => '00011', 
      '롯데(현대)택배' => '00012',
      '드림택배(KG 로지스)' => '00001',
      '우체국택배' => '00007',
      '로젠택배' => '00002',
      '우편등기' => '00008',
      '대신택배' => '00021',
      '일양로지스' => '00022',
      'ACI' => '00023',
      'WIZWA' => '00025',
      '경동택배' => '00026',
      '천일택배' => '00027',
      'KGL(해외배송)' => '00028',
      'OCS Korea' => '00031',
      'GTX 택배' => '00033',
      '합동택배' => '00035',
      '건영택배' => '00037',
      '기타' => '00099'
    }
  end

  def result
    colValue = params[:colValue0].collect { |key, value| value }
    colOptPrice = params[:colOptPrice].collect { |key, value| value }
    colCount = params[:colCount].collect { |key, value| value }
    
    option = ""
    puts colValue
    for i in 0...colValue.length
      option += "<ProductOption>
                  <useYn>Y</useYn>
                  <colOptPrice>" + colOptPrice[i] + "</colOptPrice><colValue0>" + colValue[i] + "</colValue0><colCount>" + colCount[i] + "</colCount></ProductOption>"
    end

    puts option

    url = URI("http://api.11st.co.kr/rest/prodservices/product")

    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'text/xml; charset=euc-kr'
    # request["openapikey"] = ENV["openapikey"]
    request["cache-control"] = 'no-cache'
    request.body = "
    <Product>
      <dispCtgrNo>1010478</dispCtgrNo>

      # 상품명
      <prdNm>#{params[:prdNm]}</prdNm>

      # 브랜드 명
      <brand>#{params[:brand]}</brand>

      # 대표 이미지 - 300x300 이상, jpg, jpeg, png만
      <prdImage01>https://picsum.photos/300/300</prdImage01>
      <prdImage02>https://picsum.photos/400/400</prdImage02>
      <prdImage03>https://picsum.photos/400/399</prdImage03>
      <htmlDetail>
        <![CDATA[
          <h1>탑텐 폴리리넨 스트라이프 반팔티 </h1>
          <div style='text-align : center'>
          <h2 style='color: blue'> 다양한 컬러의 스트라이프 무늬로 이루어져 있어 밝고 화사한 느낌을 줍니다 </h2>
          </div>
        ]]>
      </htmlDetail>

    
      # 판매가격
      <selPrc>#{params[:product][:selPrc]}</selPrc>

      # 재고수량
      <prdSelQty>#{params[:product][:prdSelQty]}</prdSelQty>

      # 택배사
      <dlvEtprsCd>#{params[:dlvEtprsCd]}</dlvEtprsCd>

      # 배송비 종류 01 : 무료, 02 : 고정 배송비, ...
      # 조건별 배송비 등 설정해야할 것 많을 듯
      <dlvCstInstBasiCd>#{params[:dlvCstInstBasiCd]}</dlvCstInstBasiCd>
          
      # 배송비
      <dlvCstInfoCd>#{params[:product][:dlvCstInfoCd]}</dlvCstInfoCd>

      # 무료 배송비 기준
      <PrdFrDlvBasiAmt>#{params[:product][:PrdFrDlvBasiAmt]}</PrdFrDlvBasiAmt>

      # 묶음 배송 여부 N : 불가
      <bndlDlvCnYn>#{params[:bndlDlvCnYn]}</bndlDlvCnYn>

      # (배송비?) 결제 방법 01 : 선결제 가능, 02 : 선결제 불가, 03: 선결제 필수
      <dlvCstPayTypCd>#{params[:dlvCstPayTypCd]}</dlvCstPayTypCd>

      # 제주 추가 배송비
      <jejuDlvCst>#{params[:product][:jejuDlvCst]}</jejuDlvCst>

      # 도서산간 추가 배송비
      <islandDlvCst>#{params[:product][:islandDlvCst]}</islandDlvCst>

      # 출고지 주소 코드
      ## 알아보아야 함
      <addrSeqOut>asdfasd</addrSeqOut>
      <addrSeqIn>SOIEF</addrSeqIn>

      # 반품 배송비
      <rtngdDlvCst>#{params[:product][:rtngdDlvCst]}</rtngdDlvCst>

      # 교환 배송비
      <exchDlvCst>#{params[:product][:exchDlvCst]}</exchDlvCst>

      # A/S 안내, 공백X
      <asDetail>#{params[:asDetail]}</asDetail>

      # 반품/교환 안내, 공백X
      <rtngExchDetail>#{params[:rtngExchDetail]}</rtngExchDetail>

      ##옵션

      # 선택형 옵션
      <optSelectYn>Y</optSelectYn>

      # 고정값
      <txtColCnt>1</txtColCnt>

      # 옵션명
      <colTitle>#{params[:colTitle]}</colTitle>

      # 옵션 노출 방식 00 : 등록순
      <prdExposeClfCd>00</prdExposeClfCd>

      

      #{option}
      # 디폴트 값
      ########
      # 고정가판매: 01
      <selMthdCd>01</selMthdCd>
      <prdTypCd>01</prdTypCd>
      <rmaterialTypCd>05</rmaterialTypCd>
      <orgnTypCd>03</orgnTypCd>
      <orgnNmVal>상세설명참조</orgnNmVal>
      <beefTraceStat>02</beefTraceStat>
      <suplDtyfrPrdClfCd>01</suplDtyfrPrdClfCd>
      <forAbrdBuyClf>01</forAbrdBuyClf>
      <prdStatCd>01</prdStatCd>
      <minorSelCnYn>Y</minorSelCnYn>
      <dlvWyCd>01</dlvWyCd>
      <gblDlvYn>N</gblDlvYn>
      <selTermUseYn>N</selTermUseYn>
      <dlvCnAreaCd>01</dlvCnAreaCd>
      <dlvClf>02</dlvClf>

      # 상품정보제공고시 
      <ProductNotification>
        <type>891011</type>
        <item>
        <code>11835</code>
        <name>상세 설명 참조</name>
        </item>
        <item>
        <code>23759095</code>
        <name>상세 설명 참조</name>
        </item>
        <item>
        <code>23760437</code>
        <name>상세 설명 참조</name>
        </item>
        <item>
        <code>23760034</code>
        <name>상세 설명 참조</name>
        </item>
        <item>
        <code>23759468</code>
        <name>상세 설명 참조</name>
        </item>
        <item>
        <code>23759308</code>
        <name>상세 설명 참조</name>
        </item>
        <item>
        <code>11905</code>
        <name>상세 설명 참조</name>
        </item>
        <item>
        <code>23756520</code>
        <name>상세 설명 참조</name>
        </item>
        <item>
        <code>23760386</code>
        <name>상세 설명 참조</name>
        </item>
      </ProductNotification>

      #판매자 상품코드
      <sellerPrdCd>selload1212</sellerPrdCd>          
          

      
      

      
    </Product>"
    @response = http.request(request).read_body.encode('UTF-8',replace: '?')
  end

  def list
    # 상품조회코드 (sellerPrdCd) 로 등록된 상품 일괄조회 

    search_query = "selload1212"

    url = URI("http://api.11st.co.kr/rest/prodmarketservice/sellerprodcode/#{search_query}")

    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Get.new(url)
    request["openapikey"] = ENV["openapikey"]
    request["Content-Type"] = 'text/xml'

    response = http.request(request)
    @list = response.read_body
  end

  def edit
    # list로 기본적인 상품정보를 얻어온 후 params로 넘겨줘야 기존 edit form 채워줄수 있음
    # 상품코드 PrdCd 입력 후 상품등록과 똑같은 형식의 Body를 넣어 요청 시 기존의 상품에 덮어씌우는 방식으로 수정됨
    require 'uri'
    require 'net/http'

    product_num = '2126439033'

    url = URI("http://api.11st.co.kr/rest/prodservices/product/#{product_num}")

    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Put.new(url)
    request["openapikey"] = ENV["openapikey"]
    request["Content-Type"] = 'text/xml'
    request.body = "
        <Product>
          <dispCtgrNo>1010478</dispCtgrNo>
          <prdNm>톱텐 폴리리넨 스트라이프 반팔티</prdNm>
          <brand>톱텐</brand>
          <prdImage01>https://picsum.photos/300/300</prdImage01>
          <prdImage02>https://picsum.photos/400/400</prdImage02>
          <prdImage03>https://picsum.photos/400/399</prdImage03>
          <htmlDetail>
            <![CDATA[
              <h1>톱텐 폴리리넨 스트라이프 반팔티 </h1>
              <div style=\"text-align : center\">
              <h2 style=\"color: blue\"> 다양한 컬러의 스트라이프 무늬로 이루어져 있어 밝고 화사한 느낌을 줍니다 </h2>
              </div>
            ]]>
          </htmlDetail>
          <selPrc>70000</selPrc>
          <prdSelQty>10</prdSelQty>
          <dlvEtprsCd>00011</dlvEtprsCd>
          <dlvCstInstBasiCd>01</dlvCstInstBasiCd>
          <bndlDlvCnYn>N</bndlDlvCnYn>
          <dlvCstPayTypCd>03</dlvCstPayTypCd>
          <jejuDlvCst>0</jejuDlvCst>
          <islandDlvCst>0</islandDlvCst>
          <addrSeqOut>asdfasd</addrSeqOut>
          <addrSeqIn>SOIEF</addrSeqIn>
          <rtngdDlvCst>5000</rtngdDlvCst>
          <exchDlvCst>5000</exchDlvCst>
          <asDetail>.</asDetail>
          <rtngExchDetail>.</rtngExchDetail>
          <selMthdCd>01</selMthdCd>
          <prdTypCd>01</prdTypCd>
          <rmaterialTypCd>05</rmaterialTypCd>
          <beefTraceStat>02</beefTraceStat>
          <suplDtyfrPrdClfCd>01</suplDtyfrPrdClfCd>
          <forAbrdBuyClf>01</forAbrdBuyClf>
          <prdStatCd>01</prdStatCd>
          <minorSelCnYn>Y</minorSelCnYn>
          <dlvWyCd>01</dlvWyCd>
          <gblDlvYn>N</gblDlvYn>
          <selTermUseYn>N</selTermUseYn>
          <dlvCnAreaCd>01</dlvCnAreaCd>
          <dlvClf>02</dlvClf>
          <ProductNotification>
            <type>891011</type>
            <item>
            <code>11835</code>
            <name>빨강</name>
            </item>
            <item>
            <code>23759095</code>
            <name>한국</name>
            </item>
            <item>
            <code>23760437</code>
            <name>010-1232-4124</name>
            </item>
            <item>
            <code>23760034</code>
            <name>Free</name>
            </item>
            <item>
            <code>23759468</code>
            <name>면</name>
            </item>
            <item>
            <code>23759308</code>
            <name>2018/07/20</name>
            </item>
            <item>
            <code>11905</code>
            <name>홍길동</name>
            </item>
            <item>
            <code>23756520</code>
            <name>대충해</name>
            </item>
            <item>
            <code>23760386</code>
            <name>없음</name>
            </item>
          </ProductNotification>
        </Product>"

    response = http.request(request)
    puts response.read_body
  end

  def qna_list
    # 질문 리스트 예찬이형이 qna확인 했다고해서 걍 심심해서 넣엇슴
    # 최대 조회기간 일주일임
    # Path parameter StartTime EndTime answerstatus(00 / 01 / 02) 필요
    # YYYYMMDD 포맷! 

    url = URI("http://api.11st.co.kr/rest/prodqnaservices/prodqnalist/20180720/20180725/00")

    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Get.new(url)
    request["openapikey"] = ENV["openapikey"]
    request["Content-Type"] = 'text/xml'
    request["Cache-Control"] = 'no-cache'
    request["Postman-Token"] = '749827ea-145c-4acc-a7ce-f65e36071dbb'

    response = http.request(request)
    puts response.read_body
  end

end
