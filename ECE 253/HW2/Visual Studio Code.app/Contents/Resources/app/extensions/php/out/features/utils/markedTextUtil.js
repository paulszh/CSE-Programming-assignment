/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
function textToMarkedString(text) {
    return text.replace(/[\\`*_{}[\]()#+\-.!]/g, '\\$&'); // escape markdown syntax tokens: http://daringfireball.net/projects/markdown/syntax#backslash
}
exports.textToMarkedString = textToMarkedString;
//# sourceMappingURL=https://ticino.blob.core.windows.net/sourcemaps/b813d12980308015bcd2b3a2f6efa5c810c33ba5/extensions/php/out/features/utils/markedTextUtil.js.map
