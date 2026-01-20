% SetTargetCoordinates.m - Safe Field Detection Version
target_x = -500; 
target_y = 0;    
model = 'x2axes_arm';

fprintf('Starting Ultra-Safe Link and Repair for: %s...\n', model);

try
    load_system(model);
    load_system('sm_lib');
catch
    fprintf('Error: Ensure model and Simscape are available.\n'); return;
end

% 1. المسارات (كما حددناها سابقاً)
solver_path = 'x2axes_arm/Robot model/Solver Configuration';
world_path  = 'x2axes_arm/Robot model/World';
subsystem   = 'x2axes_arm/Robot model';

% 2. إعداد الهدف
fprintf('Step 1: Setting up Target Blocks...\n');
target_sphere_name = [subsystem '/Target_Marker'];
transform_name = [subsystem '/Target_Transform'];

if ~isempty(find_system(subsystem, 'Name', 'Target_Marker')), delete_block(target_sphere_name); end
if ~isempty(find_system(subsystem, 'Name', 'Target_Transform')), delete_block(transform_name); end

add_block('sm_lib/Body Elements/Spherical Solid', target_sphere_name, 'Position', [600, 200, 650, 250]);
add_block('sm_lib/Frames and Transforms/Rigid Transform', transform_name, 'Position', [500, 200, 550, 250]);

set_param(transform_name, 'TranslationMethod', 'Cartesian');
set_param(transform_name, 'TranslationStandardOffset', sprintf('[%f, %f, 0]', target_x, target_y));
set_param(target_sphere_name, 'SphereRadius', '20');

% 3. الربط الفيزيائي الذكي (The Smart Weld)
fprintf('Step 2: Detecting Ports and Reconnecting...\n');
try
    ph_s = get_param(solver_path, 'PortHandles');
    ph_w = get_param(world_path, 'PortHandles');
    ph_t = get_param(transform_name, 'PortHandles');
    ph_b = get_param(target_sphere_name, 'PortHandles');

    % دالة ذكية تستخرج المنافذ الموجودة فقط لتجنب خطأ Unrecognized field
    get_available_ports = @(ph) [ ...
        if_exists(ph, 'LConn'), ...
        if_exists(ph, 'RConn'), ...
        if_exists(ph, 'Conn')];

    s_ports = get_available_ports(ph_s);
    w_ports = get_available_ports(ph_w);
    t_ports = get_available_ports(ph_t);
    b_ports = get_available_ports(ph_b);

    if isempty(s_ports) || isempty(w_ports)
        error('Could not find any physical ports on Solver or World blocks.');
    end

    % تنظيف المسارات القديمة
    line_s = get_param(s_ports(1), 'Line'); 
    if line_s ~= -1, delete_line(line_s); end

    % اللحام الرئيسي (المنقذ من الخطأ الطويل)
    add_line(subsystem, s_ports(1), w_ports(1), 'autorouting', 'on');
    fprintf('  [OK] Solver welded to World.\n');

    % ربط الهدف بالشبكة
    add_line(subsystem, w_ports(1), t_ports(1), 'autorouting', 'on');
    add_line(subsystem, t_ports(2), b_ports(1), 'autorouting', 'on');

    fprintf('\n*** SUCCESS: System Repaired and Target Visible ***\n');
    save_system(model);
catch ME
    fprintf('  Connection Error: %s\n', ME.message);
end

% دالة مساعدة للتحقق من وجود الحقل في الـ Structure
function out = if_exists(s, field)
    if isfield(s, field)
        out = s.(field);
    else
        out = [];
    end
end