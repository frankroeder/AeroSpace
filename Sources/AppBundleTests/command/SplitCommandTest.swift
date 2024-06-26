import XCTest
import Common
@testable import AppBundle

final class SplitCommandTest: XCTestCase {
    override func setUpWithError() throws { setUpWorkspacesForTests() }

    func testSplit() {
        var start: Window!
        let root = Workspace.get(byName: name).rootTilingContainer.apply {
            start = TestWindow(id: 1, parent: $0)
            TestWindow(id: 2, parent: $0)
        }
        _ = start.focus()

        SplitCommand(args: SplitCmdArgs(rawArgs: [], .vertical)).run(.focused)
        XCTAssertEqual(root.layoutDescription, .h_tiles([
            .v_tiles([
                .window(1)
            ]),
            .window(2),
        ]))
    }

    func testSplitOppositeOrientation() {
        var start: Window!
        let root = Workspace.get(byName: name).rootTilingContainer.apply {
            start = TestWindow(id: 1, parent: $0)
            TestWindow(id: 2, parent: $0)
        }
        _ = start.focus()

        SplitCommand(args: SplitCmdArgs(rawArgs: [], .opposite)).run(.focused)
        XCTAssertEqual(root.layoutDescription, .h_tiles([
            .v_tiles([
                .window(1)
            ]),
            .window(2),
        ]))
    }

    func testChangeOrientation() {
        var start: Window!
        let root = Workspace.get(byName: name).rootTilingContainer.apply {
            TilingContainer.newVTiles(parent: $0, adaptiveWeight: 1).apply {
                start = TestWindow(id: 1, parent: $0)
            }
            TestWindow(id: 2, parent: $0)
        }
        _ = start.focus()

        SplitCommand(args: SplitCmdArgs(rawArgs: [], .horizontal)).run(.focused)
        XCTAssertEqual(root.layoutDescription, .h_tiles([
            .h_tiles([
                .window(1)
            ]),
            .window(2),
        ]))
    }

    func testToggleOrientation() {
        var start: Window!
        let root = Workspace.get(byName: name).rootTilingContainer.apply {
            TilingContainer.newVTiles(parent: $0, adaptiveWeight: 1).apply {
                start = TestWindow(id: 1, parent: $0)
            }
            TestWindow(id: 2, parent: $0)
        }
        _ = start.focus()

        SplitCommand(args: SplitCmdArgs(rawArgs: [], .opposite)).run(.focused)
        XCTAssertEqual(root.layoutDescription, .h_tiles([
            .h_tiles([
                .window(1)
            ]),
            .window(2),
        ]))
    }
}
