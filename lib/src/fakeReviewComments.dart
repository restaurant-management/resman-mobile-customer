class ReviewCommentModal {
  final String avatar;
  final String name;
  final String comment;
  final DateTime createAt;

  ReviewCommentModal({this.avatar, this.name, this.comment, this.createAt});

}
class FakeReviewComments{
  static final reviewComments = [
    ReviewCommentModal(
      avatar: 'https://avatars1.githubusercontent.com/u/36977998?s=460&v=4',
      name: 'Lê Hồng Hiển',
      comment: 'Món ăn rất ngon, chuẩn nhà hàng 6 sao, 3 sao của miechilan',
      createAt: DateTime(2019, 2, 20, 5, 10, 20),
    ),
    ReviewCommentModal(
      avatar: 'https://avatars0.githubusercontent.com/u/36978155?s=460&v=4',
      name: 'Phan Thanh Duy',
      comment: 'Món ăn rất chua, to, khổng lồ',
      createAt: DateTime(2018, 2, 20, 5, 10, 20),
    ),
    ReviewCommentModal(
      avatar: 'https://avatars2.githubusercontent.com/u/48937704?s=460&v=4',
      name: 'Nguyễn Trung Nguyên',
      comment: 'Món ăn rất ngon, chuẩn nhà hàng 6 sao, siêu đầu bếp',
      createAt: DateTime(2018, 11, 20, 5, 10, 20,),
    ),
  ];
}