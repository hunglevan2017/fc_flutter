
class DashboardEntity{
  String dashboard_name;
  int sl;
  dynamic num_percent;
  String icon_name;
  int group_dashboard_id;

  DashboardEntity({this.dashboard_name,this.sl,this.num_percent,this.icon_name,this.group_dashboard_id});

  factory DashboardEntity.fromJSON(Map<String,dynamic> json) => DashboardEntity(
      dashboard_name: json['dashboard_name'] as String,
      sl: json['sl'] as int,
      num_percent: json['num_percent'],
      icon_name: json['icon_name'] as String,
      group_dashboard_id: json['group_dashboard_id'] as int
    );

}