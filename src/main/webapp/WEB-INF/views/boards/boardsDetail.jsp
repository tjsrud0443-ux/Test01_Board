<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"
	integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
	crossorigin="anonymous"></script>

<style>
* {
	box-sizing: border-box;
}

.title {
	text-align: center;
	font-size: xx-large;
	font-weight: 700;
}

.body {
	padding: 30px;
}

.body>div {
	border-top: 1px solid rgb(201, 201, 201);
	border-bottom: 1px solid rgb(201, 201, 201);
	display: flex;
	align-items: center;
}

.postTitle>span {
	font-weight: bold;
	background-color: rgb(235, 234, 234);
	height: 50px;
	width: 10%;
	line-height: 50px;
	padding-left: 15px;
}

.postTitle>input {
	width: 100%;
	height: 50px;
	border: 0px;
}

.content>span {
	font-weight: bold;
	background-color: rgb(235, 234, 234);
	height: 300px;
	width: 10%;
	line-height: 300px;
	padding-left: 15px;
}

.content>input {
	width: 100%;
	height: 50px;
	border: 0px;
}

.btns>span {
	font-weight: bold;
}

.btns {
	text-align: center;
}

.hiddenBtn {
	display: none;
}

/* Comment 부분 */
.replyAll {
	padding: 30px;
}

.uploadReply {
	height: 55px;
}

.lookReply {
	padding: 20px 20px;
}

.replyWriter {
	font-weight: bold;
}

.reply {
	display: flex;
}
.replyHidden{
	display:none;
}
.ori{
height: 50px; font-size: large;}
</style>
</head>

<body>
	<div class="title">글쓰기</div>
	<form id="form" action="/boards/update">
		<div class="body">
			<div class="postTitle">
				<span contenteditable="false">글번호</span><input type="text" id="seq"
					name="seq" value="${dto.seq}"
					style="height: 50px; font-size: large;" disabled> 
					<input type="hidden" id="defaultTitle" value="${dto.title}">
			</div>
			<div class="postTitle">
				<span contenteditable="false">제목</span><input type="text" id="title"
					name="title" class="change" value="${dto.title}"
					style="height: 50px; font-size: large;" disabled><input
					type="hidden" class="newTitle" value="${dto.title}">
			</div>
			<div class="postTitle">
				<span contenteditable="false">작성일</span><input type="text"
					value="${dto.write_date}" style="height: 50px; font-size: large;"
					disabled>
			</div>
			<div class="postTitle">
				<span contenteditable="false">조회수</span><input type="text"
					value="${dto.view_count}" style="height: 50px; font-size: large;"
					disabled>
			</div>
			<div class="content">
				<span contenteditable="false">내용</span><input type="text"
					id="contents" name="contents" class="change"
					value="${dto.contents}" style="height: 300px; font-size: large;"
					data-ori="${dto.contents}" disabled><input type="hidden"
					id="defaultContents" value="${dto.contents}">
			</div>
			
		</div>
		<div class="btns">
			<c:if test="${loginId==dto.writer}">
				<button type="button" class="basicBtn" id="update">수정하기</button>
				<a href="/boards/delete?seq=${dto.seq}"><input type="button"
					class="basicBtn" id="delBtn" value="삭제하기"></a>

				<input type="button" id="complete" class="hiddenBtn" value="수정완료">
				<input type="button" id="cancelBtn" class="hiddenBtn" value="수정취소">
			</c:if>
			<a href="/boards/list?cPage=${cPage}"><input type="button" class="basicBtn"
				id="backBtn" value="돌아가기"></a>
		</div>
	</form>

	<hr>


										<!-- 댓글 -->
	
	<div class="replyContainer">

		<form action="/replys/insert" method="post" class="replyFrm">
			<div class="replyContentsDiv">

					<input type="hidden" name="parent_seq" class="inputParent_seq" value="${dto.seq}"> 
					<input type="hidden" name="writer" class="inputWriter" value="${loginId}"> 
					<input type="hidden" name="contents" class="inputContents"> 
					<input type="text" placeholder="댓글을 남겨보세요." class="inputReply">
					
				<button class="replyBtn" type="submit">등록</button>
			</div>
		</form>
		<div id="replyList"></div>
	</div>

	<script>
		$(".replyFrm").on("submit", function() {
			$(".inputContents").val($(".inputReply").val());
		})
		
	
		let seq = "${dto.seq}";
		let writer = "${dto.writer}";
		let cpage = "${cPage}";
		let loginId = "${loginId}";
			
		$(function(){
			$.ajax({
				url:"/boards/replyList",	
				data:{seq:seq},
				dataType:"json"
			}).done(function(resp){ // Json으로 들어온 값을 다시 역직렬화 해야 함.
				
				for(let i of resp){
					if(seq == i.parent_seq){
						let replyDiv = $("<div>").addClass("replyDiv");
						
						replyDiv.append(
								$("<div>").addClass("reply replyWriter").text(i.writer),
								$("<div>").addClass("reply replyContents").attr("data-origin", i.contents).text(i.contents),
								$("<div>").addClass("reply replyWrite_date").text(i.write_date),
								$("<hr>").attr("style","width:97%;")

								);
						
						if(loginId == i.writer){
							let replyBtnDiv = $("<div>").addClass("replyBtnDiv")
							
							let upFrm = $("<form>").addClass("upFrm").attr({
								action : "/replys/update",
								method : "post"
							})
							
							upFrm.append(
								$("<input>").addClass("inputCon").attr({
								type:"hidden",
								name:"contents"}),
							
								$("<input>").addClass("inputSeq").attr({
									type:"hidden",
									name:"seq",
									value: i.seq}),
								
								$("<input>").addClass("inputParent_seq").attr({
									type:"hidden",
									name:"parent_seq",
									value: i.parent_seq}),
							
								$("<button>").addClass("upBtn rBtn").attr("type","button").text("수정"),
								$("<button>").addClass("saveBtn rsBtn").attr("type","submit").text("저장").hide(),
								$("<button>").addClass("bBtn rsBtn").attr("type","button").text("취소").hide()
							
							);
							
							
							let deleteFrm = $("<form>").addClass("deleteFrm").attr({
								action : "/replys/delete",
								method : "post"
							})
							
							deleteFrm.append(
								$("<input>").addClass("inputSeq").attr({
								type:"hidden",
								name:"seq",
								value: i.seq
							}),
							
							$("<input>").addClass("inputParent_seq").attr({
								type:"hidden",
								name:"parent_seq",
								value: i.parent_seq}),
							
							$("<input>").addClass("cPage").attr({
								type:"hidden",
								name:"cpage",
								value: cpage}),
							
							$("<button>").addClass("dBtn").attr("type","submit").text("삭제")
							)
							replyBtnDiv.append(upFrm,deleteFrm);
							replyDiv.append(replyBtnDiv);
						}
					$("#replyList").append(replyDiv);
					}
				}
			});
		});
		
		// 게시글
		$("#update").on("click", function() {
			$(".change").prop('disabled', false);
			$(".hiddenBtn").show();
			$(".basicBtn").hide();
		});

		$("#complete").on("click", function() {
			$("#seq").prop('disabled', false);
			$("#form").submit();
		})

		$("#cancelBtn").on("click", function() {
			$(".change").prop('disabled', true);
			$(".hiddenBtn").hide();
			$(".basicBtn").show();
			$("#title").val($("#defaultTitle").val());
			$("#contents").val($("#defaultContents").val());
		})

		
		// 코멘트 -----------------------------
		$(document).on("click", ".upBtn", function(){
			let replyDiv = $(this).closest(".replyDiv");
			replyDiv.find(".replyContents").attr("contenteditable", "true");

			$(this).siblings(".rsBtn").show();
    		$(this).hide();
    		replyDiv.find(".dBtn").hide();
		})
	
		$(document).on("click", ".bBtn", function() {
			let replyDiv = $(this).closest(".replyDiv");
			let originText = replyDiv.find(".replyContents").data("origin");
			replyDiv.find(".replyContents").html(originText).attr("contenteditable", "false");
			$(this).hide();
			$(this).siblings(".rsBtn").hide();
			$(this).siblings(".upBtn").show();
			replyDiv.find(".dBtn").show();
		});

		$(document).on("submit", ".upFrm", function(){
			$(this).find(".inputCon").val($(this).closest(".replyDiv").find(".replyContents").text());
		});

		
	</script>
</body>

</html>